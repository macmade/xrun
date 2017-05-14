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
 * @file        XRArguments.m
 * @copyright   (c) 2017, Jean-David Gadina - www.xs-labs.com
 */

#import "XRArguments.h"

NS_ASSUME_NONNULL_BEGIN

@interface XRArguments()

@property( atomic, readwrite, assign           ) BOOL                    showHelp;
@property( atomic, readwrite, assign           ) BOOL                    showVersion;
@property( atomic, readwrite, strong           ) NSArray< NSString * > * actions;
@property( atomic, readwrite, strong, nullable ) NSString              * project;
@property( atomic, readwrite, strong           ) NSArray< NSString * > * schemes;
@property( atomic, readwrite, strong, nullable ) NSError               * error;
@property( atomic, readwrite, strong           ) NSString              * executable;

- ( void )parse: ( NSArray< NSString * > * )args;

@end

NS_ASSUME_NONNULL_END

@implementation XRArguments

- ( instancetype )init
{
    return [ self initWithArguments: NULL count: 0 ];
}

- ( instancetype )initWithArguments: ( const char * _Nonnull * _Nullable )argv count: ( int )argc
{
    NSMutableArray * args;
    NSString       * arg;
    int              i;
    
    if( ( self = [ super init ] ) )
    {
        self.actions    = @[];
        self.schemes    = @[];
        self.executable = @"xrun";
        
        if( argc > 0 )
        {
            self.executable = [ NSString stringWithCString: argv[ 0 ] encoding: NSUTF8StringEncoding ];
        }
        
        if( argc > 1 && argv != NULL )
        {
            args = [ NSMutableArray new ];
            
            for( i = 1; i < argc; i++ )
            {
                if( argv[ i ] == NULL )
                {
                    continue;
                }
                
                arg = [ NSString stringWithCString: argv[ i ] encoding: NSUTF8StringEncoding ];
                
                if( arg != nil )
                {
                    [ args addObject: arg ];
                }
            }
            
            [ self parse: [ NSArray arrayWithArray: args ] ];
        }
    }
    
    return self;
}

- ( void )parse: ( NSArray< NSString * > * )args
{
    NSEnumerator                 * enumerator;
    NSString                     * arg;
    NSMutableArray< NSString * > * actions;
    NSMutableArray< NSString * > * schemes;
    
    enumerator = [ args objectEnumerator ];
    actions    = [ NSMutableArray new ];
    schemes    = [ NSMutableArray new ];
    
    while( ( arg = [ enumerator nextObject ] ) )
    {
        loop:
        
        if( [ arg isEqualToString: @"-h" ] )
        {
            self.showHelp = YES;
            
            continue;
        }
        
        if( [ arg isEqualToString: @"-v" ] )
        {
            self.showVersion = YES;
            
            continue;
        }
        
        if( [ arg hasPrefix: @"--" ] && arg.length > 2 )
        {
            [ actions addObject: [ arg substringFromIndex: 2 ] ];
            
            continue;
        }
        
        if( [ arg isEqualToString: @"-project" ] )
        {
            arg = [ enumerator nextObject ];
            
            if( arg == nil )
            {
                self.error = [ self errorWithDescription: @"No project name provided" ];
                
                break;
            }
            
            self.project = arg;
        }
        
        if( [ arg isEqualToString: @"-schemes" ] )
        {
            while( ( arg = [ enumerator nextObject ] ) )
            {
                if( [ arg hasPrefix: @"-" ] )
                {
                    goto loop;
                }
                
                [ schemes addObject: arg ];
            }
        }
    }
    
    self.actions = [ NSArray arrayWithArray: actions ];
    self.schemes = [ NSArray arrayWithArray: schemes ];
}

- ( NSString * )description
{
    NSMutableString * description;
    
    description = super.description.mutableCopy;
    
    [ description appendFormat: @"\n" ];
    [ description appendFormat: @"    Help:    %@\n", ( self.showHelp      ) ? @"Yes"                                           : @"No" ];
    [ description appendFormat: @"    Version: %@\n", ( self.showVersion   ) ? @"Yes"                                           : @"No" ];
    [ description appendFormat: @"    Actions: %@\n", ( self.actions.count ) ? [ self.actions componentsJoinedByString: @", " ] : @"--" ];
    [ description appendFormat: @"    Project: %@\n", ( self.project       ) ? self.project                                     : @"--" ];
    [ description appendFormat: @"    Schemes: %@\n", ( self.schemes.count ) ? [ self.schemes componentsJoinedByString: @", " ] : @"--" ];
    [ description appendFormat: @"    Error:   %@\n", ( self.error         ) ? self.error.localizedDescription                  : @"--" ];
    
    return description;
}

@end
