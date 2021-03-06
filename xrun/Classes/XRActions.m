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
    NSArray  * tasks;
    NSString * cert;
    
    tasks =
    @[
        [ XRSetupTasks updateHomebrew ],
        [ XRSetupTasks installCCache ],
        [ XRSetupTasks installXcodeCoveralls ]
    ];
    
    cert = [ NSProcessInfo processInfo ].environment[ @"XRUN_CERT" ];
    
    if( cert.length )
    {
        tasks = [ @[ [ XRSetupTasks importCertificate: cert ] ] arrayByAddingObjectsFromArray: tasks ];
    }
    
    if( [ NSProcessInfo processInfo ].environment[ @"TRAVIS" ] && [ [ SKShell currentShell ] commandIsAvailable: @"rvm" ] )
    {
        tasks = [ @[ [ XRSetupTasks fixRVM ] ] arrayByAddingObjectsFromArray: tasks ];
    }
    
    return [ SKTaskGroup taskGroupWithName: @"setup" tasks: tasks ];
}

+ ( id< SKRunableObject > )coverage
{
    return [ SKTaskGroup taskGroupWithName: @"coverage" tasks: @[] ];
}

+ ( id< SKRunableObject > )xcodeBuild: ( NSString * )action arguments: ( XRArguments * )args
{
    NSMutableArray * tasks;
    NSString       * scheme;
    
    tasks = [ NSMutableArray new ];
    
    if( args.schemes.count )
    {
        for( scheme in args.schemes )
        {
            [ tasks addObject: [ XRXcodeTask taskWithAction: action scheme: scheme arguments: args ] ];
        }
    }
    else
    {
        [ tasks addObject: [ XRXcodeTask taskWithAction: action scheme: nil arguments: args ] ];
    }
    
    return [ SKTaskGroup taskGroupWithName: action tasks: tasks ];
}

@end
