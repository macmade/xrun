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
 * @file        Xrun.m
 * @copyright   (c) 2017, Jean-David Gadina - www.xs-labs.com
 */

#import "Xrun.h"
#import "XRArguments.h"
#import "XRActions.h"

NS_ASSUME_NONNULL_BEGIN

@interface Xrun()

@property( atomic, readwrite, strong           ) NSString     * version;
@property( atomic, readwrite, strong, nullable ) XRArguments * args;

- ( BOOL )executeActions: ( NSArray< NSString * > * )names;

@end

NS_ASSUME_NONNULL_END

@implementation Xrun

+ ( instancetype )sharedInstance
{
    static dispatch_once_t once;
    static id              instance;
    
    dispatch_once
    (
        &once,
        ^( void )
        {
            instance = [ self new ];
        }
    );
    
    return instance;
}

- ( instancetype )init
{
    if( ( self = [ super init ] ) )
    {
        self.version                         = @"0.1.0";
        [ SKShell currentShell ].promptParts = @[ @"xrun" ];
    }
    
    return self;
}

- ( void )printHelp
{
    [ [ SKShell currentShell ] printMessage:
        @"Usage:\n"
        @"\n"
        @"%@ [-h] [-v] [actions...] [-project <projectname>] [-schemes <schemename>...]\n"
        @"\n"
        @"Available actions:\n"
        @"    \n"
        @"    --build     Build Xcode scheme(s), invoking `xcodebuild`.\n"
        @"                This requires the `-schemes` argument.\n"
        @"    \n"
        @"    --analyze   Analyze Xcode scheme(s), invoking `xcodebuild`.\n"
        @"                This requires the `-schemes` argument.\n"
        @"                Note that unlike `xcodebuild`, an analysis failure will\n"
        @"                result in a non-zero exit status.\n"
        @"    \n"
        @"    --test      Test Xcode scheme(s), invoking `xcodebuild`.\n"
        @"                This requires the `-schemes` argument.\n"
        @"    \n"
        @"    --setup     Performs initial setip and install additional dependancies.\n"
        @"                You would typically execute this in the `install:` hook.\n"
        @"    \n"
        @"    --coverage  Uploads code coverage data, if available, to coveralls.io.\n"
        @"                You would typically execute this in the `after_success:`\n"
        @"                hook.\n"
        @"\n"
        @"Options:\n"
        @"    \n"
        @"   -h           Shows the command usage.\n"
        @"   -v           Shows the XR version number.\n"
        @"   -project     Specifies the Xcode project.\n"
        @"                If none, defaults to the first available Xcode project file.\n"
        @"   -schemes     Schemes to build.\n"
        @"                You can pass multiple schemes, separated by a space.\n"
        status: SKStatusIdea,
        ( self.args.executable.length ) ? self.args.executable.lastPathComponent : @"xrun"
    ];
}

- ( void )printLicense
{
    [ [ SKShell currentShell ] printMessage:
        @"The MIT License (MIT)\n"
        @"\n"
        @"Copyright (c) 2015 Jean-David Gadina - www.xs-labs.com\n"
        @"\n"
        @"Permission is hereby granted, free of charge, to any person obtaining a copy\n"
        @"of this software and associated documentation files (the \"Software\"), to deal\n"
        @"in the Software without restriction, including without limitation the rights\n"
        @"to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n"
        @"copies of the Software, and to permit persons to whom the Software is\n"
        @"furnished to do so, subject to the following conditions:\n"
        @"\n"
        @"The above copyright notice and this permission notice shall be included in\n"
        @"all copies or substantial portions of the Software.\n"
        @"\n"
        @"THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n"
        @"IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n"
        @"FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n"
        @"AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n"
        @"LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n"
        @"OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN\n"
        @"THE SOFTWARE."
        status: SKStatusInfo
    ];
}

- ( void )printVersion
{
    [ [ SKShell currentShell ] printMessage: @"Version %@" status: SKStatusInfo, self.version ];
}

- ( BOOL )checkEnvironment
{
    NSArray< NSString * > * commands;
    NSString              * command;
    NSString              * path;
    BOOL                    error;
    
    error    = NO;
    commands =
    @[
        @"sh",
        @"brew",
        @"xcodebuild"
    ];
    
    [ [ SKShell currentShell ] printMessage: @"Checking environment"
                               status:       SKStatusSettings
                               color:        SKColorNone
    ];
    [ [ SKShell currentShell ] addPromptPart: @"env" ];
    
    for( command in commands )
    {
        [ [ SKShell currentShell ] printMessage: @"Looking for %@"
                                   status:       SKStatusSearch,
                                   [ command stringWithShellColor: SKColorCyan ]
        ];
        
        path = [ [ SKShell currentShell ] pathForCommand: command ];
        
        if( path == nil )
        {
            error = YES;
            
            [ [ SKShell currentShell ] printErrorMessage: @"%@ is not installed", command ];
        }
        else
        {
            [ [ SKShell currentShell ] printSuccessMessage: @"Installed in: %@", path ];
        }
        
    }
    
    [ [ SKShell currentShell ] removeLastPromptPart ];
    
    if( error )
    {
        [ [ SKShell currentShell ] printErrorMessage: @"Environment check failed" ];
            
        return NO;
    }
    
    [ [ SKShell currentShell ] printSuccessMessage: @"Environment check succeeded" ];
    
    return YES;
}

- ( BOOL )executeActions: ( NSArray< NSString * > * )names
{
    NSString                                      * name;
    NSMutableArray< id< SKRunableObject > >       * actions;
    id< SKRunableObject >                           action;
    NSMutableDictionary< NSString *, NSString * > * vars;
    
    actions = [ NSMutableArray new ];
    
    for( name in names )
    {
        if( [ name isEqualToString: @"setup" ] )
        {
            [ actions addObject: [ XRActions setup ] ];
        }
        else if( [ name isEqualToString: @"coverage" ] )
        {
            [ actions addObject: [ XRActions coverage ] ];
        }
        else if( [ name hasPrefix: @"xcodebuild:" ] )
        {
            [ actions addObject: [ XRActions xcodeBuild: [ name substringFromIndex: 11 ] schemes: self.args.schemes options: self.args.additionalOptions ] ];
        }
        else
        {
            [ [ SKShell currentShell ] printErrorMessage: @"Invalid action: %@", name ];
            
            return NO;
        }
    }
    
    if( actions.count == 0 )
    {
        [ [ SKShell currentShell ] printErrorMessage: @"No action provided" ];
        
        return NO;
    }
    
    vars = [ NSMutableDictionary new ];
    
    if( self.args.project.length )
    {
        [ vars setObject: self.args.project forKey: @"project" ];
    }
    
    for( action in actions )
    {
        if( [ action run: vars ] == NO )
        {
            return NO;
        }
    }
    
    return YES;
}

- ( BOOL )runWithArguments: ( XRArguments * )args
{
    self.args = args;
    
    if( args.error )
    {
        [ [ SKShell currentShell ] printError: args.error ];
        [ self printHelp ];
        
        return NO;
    }
    
    if( args.showVersion )
    {
        [ self printVersion ];
        
        return YES;
    }
    
    if( args.showHelp )
    {
        [ self printHelp ];
        
        return YES;
    }
    
    if( args.showLicense )
    {
        [ self printLicense ];
        
        return YES;
    }
    
    if( args.actions.count == 0 )
    {
        [ [ SKShell currentShell ] printErrorMessage: @"No action provided" ];
        [ self printHelp ];
        
        return NO;
    }
    
    if( [ self checkEnvironment ] == NO )
    {
        return NO;
    }
    
    if( args.actions.count )
    {
        return [ self executeActions: args.actions ];
    }
    
    return YES;
}

@end
