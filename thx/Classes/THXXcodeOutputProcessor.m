/*******************************************************************************
 * The MIT License (MIT)
 * 
 * Copyright (c) 2017 Jean-David Gadina - www.xs-labs.com
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 ******************************************************************************/

/*!
 * @file        THXXcodeOutputProcessor.m
 * @copyright   (c) 2017, Jean-David Gadina - www.xs-labs.com
 */

#import "THXXcodeOutputProcessor.h"
#import "THXXcodeMessageMatcher.h"

NS_ASSUME_NONNULL_BEGIN

@interface THXXcodeOutputProcessor()

@property( atomic, readwrite, strong, nullable ) NSMutableString                                                   * outBuffer;
@property( atomic, readwrite, strong, nullable ) NSMutableString                                                   * errBuffer;
@property( atomic, readwrite, assign           ) BOOL                                                                hasWarnings;
@property( atomic, readwrite, assign           ) BOOL                                                                hasErrors;
@property( atomic, readwrite, assign           ) BOOL                                                                hasStandardErrorOutput;
@property( atomic, readwrite, strong           ) dispatch_queue_t                                                    queue;
@property( atomic, readwrite, strong           ) NSDictionary< NSString *, NSArray< THXXcodeMessageMatcher * > * > * matchers;

- ( void )processMatchesInString: ( NSString * )str;
- ( BOOL )processString: ( NSString * )str withMatcher: ( THXXcodeMessageMatcher * )matcher;

@end

NS_ASSUME_NONNULL_END

@implementation THXXcodeOutputProcessor

+ ( instancetype )defaultOutputProcessor
{
    return [ [ self alloc ] initWithMessageMatchers: [ THXXcodeMessageMatcher defaultMessageMatchers ]
                            warningMatchers:         [ THXXcodeMessageMatcher defaultWarningMatchers ]
                            errorMatchers:           [ THXXcodeMessageMatcher defaultErrorMatchers ]
           ];
}

- ( instancetype )init
{
    return [ self initWithMessageMatchers: @[] warningMatchers: @[] errorMatchers: @[] ];
}

- ( instancetype )initWithMessageMatchers: ( NSArray< THXXcodeMessageMatcher * > * )messages warningMatchers: ( NSArray< THXXcodeMessageMatcher * > * )warnings errorMatchers: ( NSArray< THXXcodeMessageMatcher * > * )errors
{
    if( ( self = [ super init ] ) )
    {
        self.queue    = dispatch_queue_create( "com.xs-labs.thx.THXXcodeOutputProcessor", DISPATCH_QUEUE_CONCURRENT );
        self.matchers = @{ @"messages" : messages, @"warnings" : warnings, @"errors" : errors };
    }
    
    return self;
}

- ( NSString * )standardErrorOutput
{
    if( self.errBuffer.length == 0 )
    {
        return nil;
    }
    
    return [ self.errBuffer copy ];
}

#pragma mark - SKTaskDelegate

- ( void )taskWillStart: ( SKTask * )task
{
    ( void )task;
    
    self.outBuffer              = [ NSMutableString new ];
    self.errBuffer              = [ NSMutableString new ];
    self.hasWarnings            = NO;
    self.hasErrors              = NO;
    self.hasStandardErrorOutput = NO;
}

- ( void )task: ( SKTask * )task didEndWithStatus: ( int )status
{
    NSString * str;
    
    ( void )task;
    ( void )status;
    
    str            = [ self.outBuffer copy ];
    self.outBuffer = nil;
    
    if( str.length )
    {
        dispatch_async
        (
            self.queue,
            ^( void )
            {
                [ self processMatchesInString: str ];
            }
        );
    }
    
    dispatch_barrier_sync( self.queue, ^( void ){} );
}

- ( void )task: ( SKTask * )task didProduceOutput: ( NSString * )output forType: ( SKTaskOutputType )type
{
    NSRange    range;
    NSString * str;
    
    ( void )task;
    
    if( type == SKTaskOutputTypeStandardError )
    {
        self.hasStandardErrorOutput = YES;
        
        [ self.errBuffer appendString: output ];
        
        return;
    }
    
    [ self.outBuffer appendString: output ];
    
    range = [ self.outBuffer rangeOfString: @"\n\n" options: NSBackwardsSearch ];
    
    if( range.location == NSNotFound )
    {
        return;
    }
    
    str = [ self.outBuffer substringWithRange: NSMakeRange( 0, range.location + range.length ) ];
    
    [ self.outBuffer deleteCharactersInRange: NSMakeRange( 0, range.location + range.length ) ];
    
    dispatch_async
    (
        self.queue,
        ^( void )
        {
            [ self processMatchesInString: str ];
        }
    );
}

- ( void )processMatchesInString: ( NSString * )str
{
    THXXcodeMessageMatcher * matcher;
    NSString               * key;
    BOOL                     match;
    
    for( key in self.matchers )
    {
        for( matcher in self.matchers[ key ] )
        {
            if( matcher.resultFormat.length == 0 )
            {
                continue;
            }
            
            match = [ self processString: str withMatcher: matcher ];
            
            if( match && [ key isEqualToString: @"warnings" ] )
            {
                self.hasWarnings = YES;
            }
            else if( match && [ key isEqualToString: @"errors" ] )
            {
                self.hasErrors = YES;
            }
        }
    }
}

- ( BOOL )processString: ( NSString * )str withMatcher: ( THXXcodeMessageMatcher * )matcher
{
    NSArray< NSTextCheckingResult * > * results;
    NSTextCheckingResult              * result;
    NSString                          * format;
    NSString                          * capture;
    NSUInteger                          i;
    
    results = [ matcher.regularExpression matchesInString: str options: ( NSMatchingOptions )0 range: NSMakeRange( 0, str.length ) ];
    
    if( results.count == 0 )
    {
        return NO;
    }
    
    for( result in results )
    {
        format = matcher.resultFormat;
        
        for( i = 1; i < result.numberOfRanges; i++ )
        {
            capture = [ str substringWithRange: [ result rangeAtIndex: i ] ];
            format  = [ format stringByReplacingOccurrencesOfString: [ NSString stringWithFormat: @"$(%lu)", ( unsigned long )i ] withString: capture ];
        }
        
        format = [ format stringByReplacingOccurrencesOfString: @"$(clear)"  withString: [ NSString stringForShellColor: SKColorNone ] ];
        format = [ format stringByReplacingOccurrencesOfString: @"$(black)"  withString: [ NSString stringForShellColor: SKColorBlack ] ];
        format = [ format stringByReplacingOccurrencesOfString: @"$(red)"    withString: [ NSString stringForShellColor: SKColorRed ] ];
        format = [ format stringByReplacingOccurrencesOfString: @"$(green)"  withString: [ NSString stringForShellColor: SKColorGreen ] ];
        format = [ format stringByReplacingOccurrencesOfString: @"$(yellow)" withString: [ NSString stringForShellColor: SKColorYellow ] ];
        format = [ format stringByReplacingOccurrencesOfString: @"$(blue)"   withString: [ NSString stringForShellColor: SKColorBlue ] ];
        format = [ format stringByReplacingOccurrencesOfString: @"$(purple)" withString: [ NSString stringForShellColor: SKColorPurple ] ];
        format = [ format stringByReplacingOccurrencesOfString: @"$(white)"  withString: [ NSString stringForShellColor: SKColorWhite ] ];
        format = [ format stringByReplacingOccurrencesOfString: @"$(cyan)"   withString: [ NSString stringForShellColor: SKColorCyan ] ];
        
        if( format.length )
        {
            [ [ SKShell currentShell ] printMessage: @"%@" status: matcher.status, format ];
        }
    }
    
    return YES;
}

@end
