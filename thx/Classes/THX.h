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
 * @header      THX.h
 * @copyright   (c) 2017, Jean-David Gadina - www.xs-labs.com
 */

#import <Foundation/Foundation.h>
#import "THXObject.h"
#import "THXRunableObject.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM( NSInteger, THXStatus )
{
    THXStatusSuccess,
    THXStatusFatal,
    THXStatusError,
    THXStatusWarning,
    THXStatusInfo,
    THXStatusDebug,
    THXStatusBuild,
    THXStatusInstall,
    THXStatusIdea,
    THXStatusSettings,
    THXStatusSecurity,
    THXStatusExecute,
    THXStatusSearch
};

typedef NS_ENUM( NSInteger, THXColor )
{
    THXColorNone,
    THXColorBlack,
    THXColorRed,
    THXColorGreen,
    THXColorYellow,
    THXColorBlue,
    THXColorPurple,
    THXColorWhite,
    THXColorCyan
};

@interface THX: THXObject < THXRunableObject >

@property( atomic, readonly ) NSString * version;
@property( atomic, readonly ) BOOL       terminalSupportsColors;

+ ( instancetype )sharedInstance;

- ( void )printHelp;
- ( void )printVersion;
- ( void )printError: ( nullable NSError * )error;
- ( void )printError: ( nullable NSError * )error step: ( nullable NSString * )step;
- ( void )printErrorMessage: ( NSString * )message;
- ( void )printErrorMessage: ( NSString * )message step: ( nullable NSString * )step;
- ( void )printMessage: ( NSString * )message status: ( THXStatus )status color: ( THXColor )color;
- ( void )printMessage: ( NSString * )message step: ( nullable NSString * )step status: ( THXStatus )status color: ( THXColor )color;
- ( BOOL )checkEnvironment;
- ( BOOL )checkIfCommandIsAvailable: ( NSString * )command;

@end

NS_ASSUME_NONNULL_END
