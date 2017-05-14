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
 * @file        XRActions.m
 * @copyright   (c) 2017, Jean-David Gadina - www.xs-labs.com
 */

#import "XRActions.h"
#import "XRSetupTasks.h"
#import "XRArguments.h"
#import "XRXcodeTask.h"
#import "XRXcodeTask.h"

@implementation XRActions

+ ( id< SKRunableObject > )setup
{
    NSArray * tasks;
    
    tasks =
    @[
        [ XRSetupTasks fixRVM ],
        [ XRSetupTasks updateHomebrew ],
        [ XRSetupTasks installCCache ],
        [ XRSetupTasks installXcodeCoveralls ]
    ];
    
    return [ SKTaskGroup taskGroupWithName: @"setup" tasks: tasks ];
}

+ ( id< SKRunableObject > )build: ( NSArray< NSString * > * )schemes;
{
    NSMutableArray * tasks;
    NSString       * scheme;
    
    tasks = [ NSMutableArray new ];
    
    for( scheme in schemes )
    {
        [ tasks addObject: [ XRXcodeTask buildTaskForScheme: scheme ] ];
    }
    
    return [ SKTaskGroup taskGroupWithName: @"build" tasks: tasks ];
}

+ ( id< SKRunableObject > )analyze: ( NSArray< NSString * > * )schemes;
{
    NSMutableArray * tasks;
    NSString       * scheme;
    
    tasks = [ NSMutableArray new ];
    
    for( scheme in schemes )
    {
        [ tasks addObject: [ XRXcodeTask analyzeTaskForScheme: scheme ] ];
    }
    
    return [ SKTaskGroup taskGroupWithName: @"analyze" tasks: tasks ];
}

+ ( id< SKRunableObject > )test: ( NSArray< NSString * > * )schemes;
{
    NSMutableArray * tasks;
    NSString       * scheme;
    
    tasks = [ NSMutableArray new ];
    
    for( scheme in schemes )
    {
        [ tasks addObject: [ XRXcodeTask testTaskForScheme: scheme ] ];
    }
    
    return [ SKTaskGroup taskGroupWithName: @"test" tasks: tasks ];
}

+ ( id< SKRunableObject > )clean: ( NSArray< NSString * > * )schemes;
{
    NSMutableArray * tasks;
    NSString       * scheme;
    
    tasks = [ NSMutableArray new ];
    
    for( scheme in schemes )
    {
        [ tasks addObject: [ XRXcodeTask cleanTaskForScheme: scheme ] ];
    }
    
    return [ SKTaskGroup taskGroupWithName: @"clean" tasks: tasks ];
}

+ ( id< SKRunableObject > )coverage
{
    NSArray * tasks;
    
    tasks =
    @[
        
    ];
    
    return [ SKTaskGroup taskGroupWithName: @"coverage" tasks: tasks ];
}

@end
