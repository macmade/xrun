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
 * @file        THXXcodeTask.m
 * @copyright   (c) 2017, Jean-David Gadina - www.xs-labs.com
 */

#import "THXXcodeTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface THXXcodeTask()

@property( atomic, readwrite, strong ) NSString * action;
@property( atomic, readwrite, strong ) NSString * scheme;

- ( instancetype )initWithAction: ( NSString * )action scheme: ( NSString * )scheme;

@end

NS_ASSUME_NONNULL_END

@implementation THXXcodeTask

+ ( instancetype )buildTaskForScheme: ( NSString * )scheme
{
    return [ [ self alloc ] initWithAction: @"build" scheme: scheme ];
}

+ ( instancetype )analyzeTaskForScheme: ( NSString * )scheme
{
    return [ [ self alloc ] initWithAction: @"analyze" scheme: scheme ];
}

+ ( instancetype )testTaskForScheme: ( NSString * )scheme
{
    return [ [ self alloc ] initWithAction: @"test" scheme: scheme ];
}

+ ( instancetype )cleanTaskForScheme: ( NSString * )scheme
{
    return [ [ self alloc ] initWithAction: @"clean" scheme: scheme ];
}

- ( instancetype )initWithAction: ( NSString * )action scheme: ( NSString * )scheme
{
    if( ( self = [ self initWithShellScript: @"xcodebuild %{action}% -scheme %{scheme}% -project %{project}%" ] ) )
    {
        self.action = action;
        self.scheme = scheme;
    }
    
    return self;
}

- ( instancetype )initWithShellScript: ( NSString * )script
{
    if( [ [ SKShell currentShell ] isCommandAvailable: @"xcpretty" ] )
    {
        script = [ NSString stringWithFormat: @"set -o pipefail && %@ | xcpretty", script ];
    }
    
    return [ super initWithShellScript: script ];
}

- ( BOOL )run: ( NSDictionary< NSString *, NSString * > * )variables
{
    BOOL                                            ret;
    NSMutableDictionary< NSString *, NSString * > * vars;
    
    [ [ SKShell currentShell ] addPromptPart: self.scheme ];
    
    vars = variables.mutableCopy;
    
    [ vars setObject: self.action forKey: @"action" ];
    [ vars setObject: self.scheme forKey: @"scheme" ];
    
    ret = [ super run: vars ];
    
    [ [ SKShell currentShell ] removeLastPromptPart ];
    
    return ret;
}

@end
