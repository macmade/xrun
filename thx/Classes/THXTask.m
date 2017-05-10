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
 * @file        THXTask.m
 * @copyright   (c) 2017, Jean-David Gadina - www.xs-labs.com
 */

#import "THXTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface THXTask()

@property( atomic, readwrite, strong, nullable ) NSError  * error;
@property( atomic, readwrite, strong           ) NSString * script;
@property( atomic, readwrite, assign           ) THXStatus  status;
@property( atomic, readwrite, strong, nullable ) NSString * step;

- ( NSError * )errorWithDescription: ( NSString * )description;

@end

NS_ASSUME_NONNULL_END

@implementation THXTask

- ( instancetype )init
{
    return [ self initWithShellScript: @"true" ];
}

- ( instancetype )initWithShellScript: ( NSString * )script
{
    return [ self initWithShellScript: script status: THXStatusExecute ];
}

- ( instancetype )initWithShellScript: ( NSString * )script status: ( THXStatus )status
{
    return [ self initWithShellScript: script step: nil status: status ];
}

- ( instancetype )initWithShellScript: ( NSString * )script step: ( nullable NSString * )step
{
    return [ self initWithShellScript: script step: step status: THXStatusExecute ];
}

- ( instancetype )initWithShellScript: ( NSString * )script step: ( nullable NSString * )step status: ( THXStatus )status
{
    if( ( self = [ super init ] ) )
    {
        self.script = script;
        self.step   = step;
        self.status = status;
    }
    
    return self;
}

- ( NSError * )errorWithDescription: ( NSString * )description
{
    return [ NSError errorWithDomain: @"com.xs-THXTask" code: 0 userInfo: @{ NSLocalizedDescriptionKey : description } ];
}

#pragma mark - THXRunableObject

- ( BOOL )runWithArguments: ( THXArguments * )args
{
    NSTask * task;
    
    ( void )args;
    
    [ [ THX sharedInstance ] printMessage: self.script step: self.step status: self.status color: THXColorYellow ];
    
    task            = [ NSTask new ];
    task.launchPath = @"/bin/sh";
    task.arguments  =
    @[
        @"-l",
        @"-c",
        self.script
    ];
    
    [ task launch ];
    [ task waitUntilExit ];
    
    if( task.terminationStatus != 0 )
    {
        self.error = [ self errorWithDescription: [ NSString stringWithFormat: @"Task exited with status %li", ( long )( task.terminationStatus ) ] ];
        
        return NO;
    }
    
    return YES;
}

@end
