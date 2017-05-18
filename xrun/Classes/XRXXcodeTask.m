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
 * @file        XRXcodeTask.m
 * @copyright   (c) 2017, Jean-David Gadina - www.xs-labs.com
 */

#import "XRXcodeTask.h"
#import "XRXcodeOutputProcessor.h"
#import "XRArguments.h"

NS_ASSUME_NONNULL_BEGIN

@interface XRXcodeTask()

@property( atomic, readwrite, strong           ) NSError     * error;
@property( atomic, readwrite, strong           ) NSString    * action;
@property( atomic, readwrite, strong, nullable ) NSString    * scheme;
@property( atomic, readwrite, strong           ) XRArguments * arguments;

- ( instancetype )initWithAction: ( NSString * )action scheme: ( nullable NSString * )scheme arguments: ( XRArguments * )args;
- ( NSString * )escapeArgument: ( NSString * )argument;

@end

NS_ASSUME_NONNULL_END

@implementation XRXcodeTask

@dynamic error;

+ ( instancetype )taskWithAction: ( NSString * )action scheme: ( nullable NSString * )scheme arguments: ( XRArguments * )args
{
    return [ [ self alloc ] initWithAction: action scheme: scheme arguments: args ];
}

- ( instancetype )initWithAction: ( NSString * )action scheme: ( nullable NSString * )scheme arguments: ( XRArguments * )args
{
    NSString * script;
    NSString * arg;
    
    script = @"xcodebuild %{action}% -project %{project}%";
    
    if( scheme.length )
    {
        script = [ script stringByAppendingFormat: @" -scheme %@", [ self escapeArgument: scheme ] ];
    }
    
    for( arg in args.additionalOptions )
    {
        script = [ script stringByAppendingFormat: @" %@", [ self escapeArgument: arg ] ];
    }
    
    if( ( self = [ self initWithShellScript: script ] ) )
    {
        self.action    = action;
        self.scheme    = scheme;
        self.arguments = args;
    }
    
    return self;
}

- ( instancetype )initWithShellScript: ( NSString * )script recoverTasks: ( nullable NSArray< SKTask * > * )recover
{
    if( ( self = [ super initWithShellScript: script recoverTasks: recover ] ) )
    {
        self.outputProcessor = [ XRXcodeOutputProcessor defaultOutputProcessor ];
    }
    
    return self;
}

- ( BOOL )run: ( NSDictionary< NSString *, NSString * > * )variables
{
    BOOL                                            ret;
    NSMutableDictionary< NSString *, NSString * > * vars;
    
    if( self.scheme.length )
    {
        [ [ SKShell currentShell ] addPromptPart: self.scheme ];
    }
    
    vars = variables.mutableCopy;
    
    [ vars setObject: self.action forKey: @"action" ];
    
    if( [ vars objectForKey: @"project" ] == nil )
    {
        {
            NSString * project;
            
            project = [ XRXcodeTask findXcodeProject ];
            
            if( project == nil )
            {
                self.error = [ self errorWithDescription: @"Cannot find an Xcode project in the current directory" ];
                
                [ [ SKShell currentShell ] printError: self.error ];
                
                return NO;
            }
            
            [ vars setObject: project forKey: @"project" ];
        }
    }
    else
    {
        vars[ @"project" ] = [ self escapeArgument: vars[ @"project" ] ];
    }
    
    self.outputProcessor.verbose = self.arguments.verbose;
    self.delegate                = self.outputProcessor;
    ret                          = [ super run: vars ];
    self.delegate                = nil;
    
    if( self.outputProcessor.hasWarnings && self.arguments.failOnWarnings )
    {
        [ [ SKShell currentShell ] printErrorMessage: @"Task produced warnings" ];
        
        ret = NO;
    }
    
    if( ret == NO && self.outputProcessor.errorDetectedOnLastOutput == NO && self.outputProcessor.lastOutputWithoutMatch.length > 0 )
    {
        [ [ SKShell currentShell ] printInfoMessage: @"Last output fro xcodebuild:\n    %@", self.outputProcessor.lastOutputWithoutMatch ];
    }
    else if( ret == NO && self.outputProcessor.errorDetectedOnLastOutput == NO && self.outputProcessor.lastOutput.length > 0 )
    {
        [ [ SKShell currentShell ] printInfoMessage: @"Last output fro xcodebuild:\n    %@", self.outputProcessor.lastOutput ];
    }
    
    if( self.scheme.length )
    {
        [ [ SKShell currentShell ] removeLastPromptPart ];
    }
    
    return ret;
}

+ ( nullable NSString * )findXcodeProject
{
    NSString * dir;
    NSString * path;
    
    dir = [ [ NSFileManager defaultManager ] currentDirectoryPath ];
    
    for( path in [ [ NSFileManager defaultManager ] contentsOfDirectoryAtPath: dir error: NULL ] )
    {
        if( [ path.pathExtension isEqualToString: @"xcodeproj" ] )
        {
            return path;
        }
    }
    
    return nil;
}

- ( NSString * )escapeArgument: ( NSString * )argument
{
    
    if( [ argument rangeOfString: @" " ].location != NSNotFound  )
    {
        argument = [ argument stringByReplacingOccurrencesOfString: @"\"" withString: @"\\\"" ];
        argument = [ NSString stringWithFormat: @"\"%@\"", argument ];
    }
    
    return argument;
}

@end
