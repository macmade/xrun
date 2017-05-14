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
@property( atomic, readwrite, assign           ) BOOL                    showLicense;
@property( atomic, readwrite, assign           ) BOOL                    verbose;
@property( atomic, readwrite, assign           ) BOOL                    noPrompt;
@property( atomic, readwrite, assign           ) BOOL                    failOnWarnings;
@property( atomic, readwrite, assign           ) BOOL                    failOnAnalyzeErrors;
@property( atomic, readwrite, strong           ) NSArray< NSString * > * actions;
@property( atomic, readwrite, strong, nullable ) NSString              * project;
@property( atomic, readwrite, strong           ) NSArray< NSString * > * schemes;
@property( atomic, readwrite, strong, nullable ) NSError               * error;
@property( atomic, readwrite, strong           ) NSString              * executable;
@property( atomic, readwrite, strong           ) NSArray< NSString * > * additionalOptions;

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
    NSMutableArray< NSString * > * additionalOptions;
    
    enumerator          = [ args objectEnumerator ];
    actions             = [ NSMutableArray new ];
    schemes             = [ NSMutableArray new ];
    additionalOptions   = [ NSMutableArray new ];
    
    while( ( arg = [ enumerator nextObject ] ) )
    {
        if
        (
               [ arg isEqualToString: @"-help" ]
            || [ arg isEqualToString: @"--help" ]
        )
        {
            self.showHelp = YES;
        }
        else if
        (
               [ arg isEqualToString: @"-version" ]
            || [ arg isEqualToString: @"--version" ]
        )
        {
            self.showVersion = YES;
        }
        else if
        (
               [ arg isEqualToString: @"-license" ]
            || [ arg isEqualToString: @"--license" ]
        )
        {
            self.showLicense = YES;
        }
        else if
        (
               [ arg isEqualToString: @"-verbose" ]
            || [ arg isEqualToString: @"--verbose" ]
        )
        {
            self.verbose = YES;
        }
        else if
        (
               [ arg isEqualToString: @"-no-prompt" ]
            || [ arg isEqualToString: @"--no-prompt" ]
        )
        {
            self.noPrompt = YES;
        }
        else if
        (
               [ arg isEqualToString: @"-fail-warn" ]
            || [ arg isEqualToString: @"--fail-warn" ]
        )
        {
            self.failOnWarnings = YES;
        }
        else if
        (
               [ arg isEqualToString: @"-fail-analyze" ]
            || [ arg isEqualToString: @"--fail-analyze" ]
        )
        {
            self.failOnAnalyzeErrors = YES;
        }
        else if
        (
               [ arg isEqualToString: @"build" ]
            || [ arg isEqualToString: @"build-for-testing" ]
            || [ arg isEqualToString: @"analyze" ]
            || [ arg isEqualToString: @"archive" ]
            || [ arg isEqualToString: @"test" ]
            || [ arg isEqualToString: @"test-without-building" ]
            || [ arg isEqualToString: @"install-src" ]
            || [ arg isEqualToString: @"install" ]
            || [ arg isEqualToString: @"clean" ]
        )
        {
            [ actions addObject: [ NSString stringWithFormat: @"xcodebuild:%@", arg ] ];
        }
        else if
        (
               [ arg isEqualToString: @"setup" ]
            || [ arg isEqualToString: @"coverage" ]
        )
        {
            [ actions addObject: arg ];
        }
        else if( [ arg isEqualToString: @"-project" ] )
        {
            arg = [ enumerator nextObject ];
            
            if( arg == nil )
            {
                self.error = [ self errorWithDescription: @"No project name provided" ];
                
                break;
            }
            
            self.project = arg;
        }
        else if( [ arg isEqualToString: @"-scheme" ] )
        {
            arg = [ enumerator nextObject ];
            
            if( arg == nil )
            {
                self.error = [ self errorWithDescription: @"No scheme provided" ];
                
                break;
            }
                
            [ schemes addObject: arg ];
        }
        else
        {
            [ additionalOptions addObject: arg ];
        }
    }
    
    self.actions           = [ NSArray arrayWithArray: actions ];
    self.schemes           = [ NSArray arrayWithArray: schemes ];
    self.additionalOptions = [ NSArray arrayWithArray: additionalOptions ];
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
