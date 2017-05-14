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

NS_ASSUME_NONNULL_BEGIN

@interface XRXcodeTask()

@property( atomic, readwrite, strong           ) NSError  * error;
@property( atomic, readwrite, strong           ) NSString * action;
@property( atomic, readwrite, strong, nullable ) NSString * scheme;

- ( instancetype )initWithAction: ( NSString * )action scheme: ( nullable NSString * )scheme options: ( NSArray< NSString * > * )options;
- ( nullable NSString * )findXcodeProject;

@end

NS_ASSUME_NONNULL_END

@implementation XRXcodeTask

@dynamic error;

+ ( instancetype )taskWithAction: ( NSString * )action scheme: ( nullable NSString * )scheme options: ( NSArray< NSString * > * )options
{
    return [ [ self alloc ] initWithAction: action scheme: scheme options: options ];
}

- ( instancetype )initWithAction: ( NSString * )action scheme: ( nullable NSString * )scheme options: ( NSArray< NSString * > * )options
{
    NSString * script;
    
    script = @"xcodebuild %{action}% -project %{project}%";
    
    if( scheme.length )
    {
        script = [ script stringByAppendingFormat: @" -scheme %@", scheme ];
    }
    
    if( options.count )
    {
        script = [ script stringByAppendingFormat: @" %@", [ options componentsJoinedByString: @" " ] ];
    }
    
    if( ( self = [ self initWithShellScript: script ] ) )
    {
        self.action = action;
        self.scheme = scheme;
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
            
            project = [ self findXcodeProject ];
            
            if( project == nil )
            {
                self.error = [ self errorWithDescription: @"Cannot find an Xcode project in the current directory" ];
                
                [ [ SKShell currentShell ] printError: self.error ];
                
                return NO;
            }
            
            [ vars setObject: project forKey: @"project" ];
        }
    }
    
    self.delegate = self.outputProcessor;
    ret           = [ super run: vars ];
    self.delegate = nil;
    
    if( self.scheme.length )
    {
        [ [ SKShell currentShell ] removeLastPromptPart ];
    }
    
    return ret;
}

- ( nullable NSString * )findXcodeProject
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

@end
