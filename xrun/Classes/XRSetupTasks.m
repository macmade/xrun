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
 * @file        XRSetupTasks.m
 * @copyright   (c) 2017, Jean-David Gadina - www.xs-labs.com
 */

#import "XRSetupTasks.h"

static NSString * __strong buildKeychainName;
static NSString * __strong buildKeychainPassword;

static void init( void ) __attribute__( ( constructor ) );
static void init( void )
{
    buildKeychainName     = [ NSUUID UUID ].UUIDString;
    buildKeychainPassword = [ NSUUID UUID ].UUIDString;
}

NS_ASSUME_NONNULL_BEGIN

@interface XRSetupTasks()

+ ( id< SKRunableObject > )createKeychain: ( NSString * )keychainName withPassword: ( NSString * )password;
+ ( id< SKRunableObject > )setDefaultKeychain: ( NSString * )keychainName;
+ ( id< SKRunableObject > )unlockKeychain: ( NSString * )keychainName withPassword: ( NSString * )password;
+ ( id< SKRunableObject > )setTimeout: ( NSUInteger )timeout forKeychain: ( NSString * )keychainName;
+ ( id< SKRunableObject > )importCertificate: ( NSString * )path inKeychain: ( NSString * )keychainName;
+ ( id< SKRunableObject > )setKeyPartitionListOfKeychain: ( NSString * )keychainName withPassword: ( NSString * )password;
+ ( id< SKRunableObject > )printIdentities;
+ ( NSString * )pathForTemporaryFileWithExtension: ( NSString * )ext;

@end

NS_ASSUME_NONNULL_END

@implementation XRSetupTasks

+ ( id< SKRunableObject > )fixRVM
{
    return [ SKOptionalTask taskWithShellScript: @"rvm get head" ];
}

+ ( id< SKRunableObject > )updateHomebrew
{
    return [ SKTask taskWithShellScript: @"brew update" ];
}

+ ( id< SKRunableObject > )installCCache
{
    return [ SKTask taskWithShellScript: @"brew install ccache" recoverTask: [ SKTask taskWithShellScript: @"brew upgrade ccache" ] ];
}

+ ( id< SKRunableObject > )installXcodeCoveralls
{
    return [ SKTask taskWithShellScript: @"brew install macmade/tap/xcode-coveralls" recoverTask: [ SKTask taskWithShellScript: @"brew upgrade xcode-coveralls" ] ];
}

+ ( id< SKRunableObject > )importCertificate: ( NSString * )b64Cert
{
    NSMutableArray< id< SKRunableObject > > * tasks;
    NSData                                  * data;
    NSString                                * cert;
    NSOperatingSystemVersion                  macOSVersion;
    
    macOSVersion = [ NSProcessInfo processInfo ].operatingSystemVersion;
    b64Cert      = [ b64Cert stringByReplacingOccurrencesOfString: @"\n" withString: @"" ];
    data         = [ [ NSData alloc ] initWithBase64EncodedString: b64Cert options: NSDataBase64DecodingIgnoreUnknownCharacters ];
    cert         = [ XRSetupTasks pathForTemporaryFileWithExtension: @"p12" ];
    tasks        = [ NSMutableArray new ];
    
    [ data writeToFile: cert atomically: YES ];

    [ tasks addObject: [ XRSetupTasks createKeychain: buildKeychainName withPassword: buildKeychainPassword ] ];
    [ tasks addObject: [ XRSetupTasks setDefaultKeychain: buildKeychainName ] ];
    [ tasks addObject: [ XRSetupTasks unlockKeychain: buildKeychainName withPassword: buildKeychainPassword ] ];
    [ tasks addObject: [ XRSetupTasks setTimeout: 36000 forKeychain: buildKeychainName ] ];
    [ tasks addObject: [ XRSetupTasks importCertificate: cert inKeychain: buildKeychainName ] ];
    
    if( macOSVersion.majorVersion >= 10 && macOSVersion.minorVersion >= 12 )
    {
        [ tasks addObject: [ XRSetupTasks setKeyPartitionListOfKeychain: buildKeychainName withPassword: buildKeychainPassword ] ];
    }
    
    [ tasks addObject: [ XRSetupTasks printIdentities ] ];
    
    return [ SKTaskGroup taskGroupWithName: @"import-cert" tasks: tasks ];
}

+ ( id< SKRunableObject > )createKeychain: ( NSString * )keychainName withPassword: ( NSString * )password
{
    return [ SKTask taskWithShellScript: [ NSString stringWithFormat: @"security create-keychain -p %@ %@", password, keychainName ] ];
}

+ ( id< SKRunableObject > )setDefaultKeychain: ( NSString * )keychainName
{
    return [ SKTask taskWithShellScript: [ NSString stringWithFormat: @"security default-keychain -s %@", keychainName ] ];
}

+ ( id< SKRunableObject > )unlockKeychain: ( NSString * )keychainName withPassword: ( NSString * )password
{
    return [ SKTask taskWithShellScript: [ NSString stringWithFormat: @"security unlock-keychain -p %@ %@", password, keychainName ] ];
}

+ ( id< SKRunableObject > )setTimeout: ( NSUInteger )timeout forKeychain: ( NSString * )keychainName
{
    return [ SKTask taskWithShellScript: [ NSString stringWithFormat: @"security set-keychain-settings -t %lu -u %@", ( unsigned long )timeout, keychainName ] ];
}

+ ( id< SKRunableObject > )importCertificate: ( NSString * )path inKeychain: ( NSString * )keychainName
{
    return [ SKTask taskWithShellScript: [ NSString stringWithFormat: @"security import %@ -k %@ -T /usr/bin/codesign -P \"\"", path, keychainName ] ];
}

+ ( id< SKRunableObject > )setKeyPartitionListOfKeychain: ( NSString * )keychainName withPassword: ( NSString * )password
{
    return [ SKTask taskWithShellScript: [ NSString stringWithFormat: @"security set-key-partition-list -S apple-tool:,apple: -s -k %@ %@", password, keychainName ] ];
}

+ ( id< SKRunableObject > )printIdentities
{
    return [ SKTask taskWithShellScript: @"security find-identity -v" ];
}

+ ( NSString * )pathForTemporaryFileWithExtension: ( NSString * )ext
{
    NSString * path;
    NSUUID   * uuid;
    
    path = nil;
    
    while( path == nil || [ [ NSFileManager defaultManager ] fileExistsAtPath: path ] )
    {
        uuid = [ NSUUID UUID ];
        path = [ [ NSTemporaryDirectory() stringByAppendingPathComponent: uuid.UUIDString ] stringByAppendingPathExtension: ext ];
    }
    
    return path;
}

@end
