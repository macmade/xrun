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
 * @file        THXAction.m
 * @copyright   (c) 2017, Jean-David Gadina - www.xs-labs.com
 */

#import "THXAction.h"
#import "THXTask.h"
#import "THXArguments.h"
#import "THX.h"

NS_ASSUME_NONNULL_BEGIN

@interface THXAction()

@property( atomic, readwrite, strong           ) NSString             * name;
@property( atomic, readwrite, strong           ) NSArray< THXTask * > * tasks;
@property( atomic, readwrite, strong, nullable ) NSError              * error;

@end

NS_ASSUME_NONNULL_END

@implementation THXAction

+ ( instancetype )setupAction
{
    THXAction * c;
    
    c       = [ THXAction new ];
    c.name  = @"setup";
    c.tasks =
    @[
        [ [ THXTask alloc ] initWithShellScript: @"brew install ccache" step: c.name status: THXStatusInstall ],
        [ [ THXTask alloc ] initWithShellScript: @"brew install macmade/tap/xcode-coveralls" step: c.name status: THXStatusInstall recoverTask: [ [ THXTask alloc ] initWithShellScript: @"brew upgrade xcode-coveralls" step: c.name status: THXStatusInstall ] ],
        [ [ THXTask alloc ] initWithShellScript: @"false" step: c.name status: THXStatusInstall ]
    ];
    
    return c;
}

+ ( instancetype )buildAction
{
    THXAction * c;
    
    c      = [ THXAction new ];
    c.name = @"build";
    
    return c;
}

+ ( instancetype )analyzeAction
{
    THXAction * c;
    
    c      = [ THXAction new ];
    c.name = @"analyze";
    
    return c;
}

+ ( instancetype )testAction
{
    THXAction * c;
    
    c      = [ THXAction new ];
    c.name = @"test";
    
    return c;
}

+ ( instancetype )coverageAction
{
    THXAction * c;
    
    c      = [ THXAction new ];
    c.name = @"coverage";
    
    return c;
}

- ( instancetype )init
{
    if( ( self = [ super init ] ) )
    {
        self.name  = @"unknown";
        self.tasks = @[];
    }
    
    return self;
}

#pragma mark - THXRunableObject

- ( BOOL )runWithArguments: ( THXArguments * )args
{
    THXTask * task;
    
    if( self.tasks.count == 0 )
    {
        self.error = [ self errorWithDescription: @"No task defined for action" ];
        
        return NO;
    }
    
    for( task in self.tasks )
    {
        [ [ THX sharedInstance ] printMessage: @"Executing action..." step: self.name status: THXStatusExecute color: THXColorNone ];
        
        if( [ task runWithArguments: args ] == NO )
        {
            self.error = task.error;
            
            return NO;
        }
        else
        {
            [ [ THX sharedInstance ] printMessage: @"Task completed successfully" step: self.name status: THXStatusSuccess color: THXColorGreen ];
        }
    }
    
    return YES;
}

@end
