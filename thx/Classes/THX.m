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
 * @file        THX.m
 * @copyright   (c) 2017, Jean-David Gadina - www.xs-labs.com
 */

#import "THX.h"
#import "THXArguments.h"

#define THX_COLOR_NONE      "\x1B[0m"
#define THX_COLOR_BLACK     "\x1B[30m"
#define THX_COLOR_RED       "\x1B[31m"
#define THX_COLOR_GREEN     "\x1B[32m"
#define THX_COLOR_YELLOW    "\x1B[33m"
#define THX_COLOR_BLUE      "\x1B[34m"
#define THX_COLOR_PURPLE    "\x1B[35m"
#define THX_COLOR_CYAN      "\x1B[36m"
#define THX_COLOR_WHITE     "\x1B[37m"

NS_ASSUME_NONNULL_BEGIN

@interface THX()

@property( atomic, readwrite, strong           ) NSError      * error;
@property( atomic, readwrite, strong           ) NSString     * version;
@property( atomic, readwrite, strong, nullable ) THXArguments * args;

- ( NSString * )stringForStatus: ( THXStatus )status;
- ( NSString * )stringForColor: ( THXColor )color;

@end

NS_ASSUME_NONNULL_END

@implementation THX

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
        self.version = @"0.1.0";
    }
    
    return self;
}

- ( void )printHelp
{
    fprintf
    (
        stdout,
        "Usage: %s [-h] [-v] [actions...] [-project <projectname>] [-schemes <schemename>...]\n"
        "\n"
        "Available actions:\n"
        "    \n"
        "    --build     Build Xcode scheme(s), invoking `xcodebuild`.\n"
        "                This requires the `-schemes` argument.\n"
        "    \n"
        "    --analyze   Analyze Xcode scheme(s), invoking `xcodebuild`.\n"
        "                This requires the `-schemes` argument.\n"
        "                Note that unlike `xcodebuild`, an analysis failure will\n"
        "                result in a non-zero exit status.\n"
        "    \n"
        "    --test      Test Xcode scheme(s), invoking `xcodebuild`.\n"
        "                This requires the `-schemes` argument.\n"
        "    \n"
        "    --setup     Performs initial setip and install additional dependancies.\n"
        "                You would typically execute this in the `install:` hook.\n"
        "    \n"
        "    --coverage  Uploads code coverage data, if available, to coveralls.io.\n"
        "                You would typically execute this in the `after_success:`\n"
        "                hook.\n"
        "\n"
        "Options:\n"
        "    \n"
        "   -h           Shows the command usage.\n"
        "   -v           Shows the THX version number.\n"
        "   -project     Specifies the Xcode project.\n"
        "                If none, defaults to the first available Xcode project file.\n"
        "   -schemes     Schemes to build.\n"
        "                You can pass multiple schemes, separated by a space.\n",
        ( self.args.executable.length ) ? self.args.executable.lastPathComponent.UTF8String : "thx"
    );
}

- ( void )printVersion
{
    fprintf( stdout, "%s\n", [ NSString stringWithFormat: @"THX version %@", self.version ].UTF8String );
}

- ( void )printError: ( nullable NSError * )error
{
    NSString * message;
    
    if( error.localizedDescription.length )
    {
        message = [ NSString stringWithFormat: @"Error: %@", error.localizedDescription ];
    }
    else
    {
        message = @"An unknown error occured";
    }
    
    [ self printMessage: message status: THXStatusError color: THXColorRed ];
}

- ( void )printErrorMessage: ( NSString * )message
{
    NSError * error;
    
    error = [ NSError errorWithDomain: NSCocoaErrorDomain code: 0 userInfo: @{ NSLocalizedDescriptionKey : message } ];
    
    [ self printError: error ];
}

- ( void )printMessage: ( NSString * )message status: ( THXStatus )status color: ( THXColor )color
{
    fprintf
    (
        stdout,
        "[ %sTHX%s ]> %s  %s%s%s\n",
        [ self stringForColor: THXColorYellow ].UTF8String,
        [ self stringForColor: THXColorNone ].UTF8String,
        [ self stringForStatus: status ].UTF8String,
        [ self stringForColor: color ].UTF8String,
        message.UTF8String,
        [ self stringForColor: THXColorNone ].UTF8String
    );
}

- ( NSString * )stringForStatus: ( THXStatus )status
{
    switch( status )
    {
        case THXStatusSuccess:  return @"✅";
        case THXStatusFatal:    return @"💣";
        case THXStatusError:    return @"⛔️";
        case THXStatusWarning:  return @"⚠️";
        case THXStatusInfo:     return @"ℹ️";
        case THXStatusDebug:    return @"🚸";
        case THXStatusBuild:    return @"⚒";
        case THXStatusInstall:  return @"📦";
        case THXStatusIdea:     return @"💡";
        case THXStatusSettings: return @"⚙️";
        case THXStatusSecurity: return @"🔑";
    }
}

- ( NSString * )stringForColor: ( THXColor )color
{
    switch( color )
    {
        case THXColorNone:      return @THX_COLOR_NONE;
        case THXColorBlack:     return @THX_COLOR_BLACK;
        case THXColorRed:       return @THX_COLOR_RED;
        case THXColorGreen:     return @THX_COLOR_GREEN;
        case THXColorYellow:    return @THX_COLOR_YELLOW;
        case THXColorBlue:      return @THX_COLOR_BLUE;
        case THXColorPurple:    return @THX_COLOR_PURPLE;
        case THXColorWhite:     return @THX_COLOR_WHITE;
        case THXColorCyan:      return @THX_COLOR_CYAN;
    }
}

#pragma mark - THXRunableObject

- ( BOOL )runWithArguments: ( THXArguments * )args
{
    self.args = args;
    
    if( args.error )
    {
        [ self printError: args.error ];
        [ self printHelp ];
        
        return NO;
    }
    
    if( args.showVersion == NO && args.showHelp == NO && args.actions.count == 0 )
    {
        [ self printErrorMessage: @"No action provided" ];
        [ self printHelp ];
        
        return NO;
    }
    
    if( args.showVersion )
    {
        [ self printVersion ];
    }
    
    if( args.showHelp )
    {
        [ self printHelp ];
    }
    
    return YES;
}

@end
