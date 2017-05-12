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
 * @file        THXSetupTasks.m
 * @copyright   (c) 2017, Jean-David Gadina - www.xs-labs.com
 */

#import "THXSetupTasks.h"

@implementation THXSetupTasks

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

+ ( id< SKRunableObject > )installXCPretty
{
    return [ SKOptionalTask taskWithShellScript: @"gem install xcpretty" ];
}

+ ( id< SKRunableObject > )installXcodeCoveralls
{
    return [ SKTask taskWithShellScript: @"brew install macmade/tap/xcode-coveralls" recoverTask: [ SKTask taskWithShellScript: @"brew upgrade xcode-coveralls" ] ];
}

@end
