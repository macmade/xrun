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
 * @file        THXXcodeMessageMatcher.m
 * @copyright   (c) 2017, Jean-David Gadina - www.xs-labs.com
 */

#import "THXXcodeMessageMatcher.h"
#import "THXRegularExpressions.h"

NS_ASSUME_NONNULL_BEGIN

@interface THXXcodeMessageMatcher()

@property( atomic, readwrite, strong ) NSString            * expression;
@property( atomic, readwrite, strong ) NSRegularExpression * regularExpression;
@property( atomic, readwrite, strong ) NSString            * resultFormat;
@property( atomic, readwrite, assign ) SKStatus              status;

@end

NS_ASSUME_NONNULL_END

@implementation THXXcodeMessageMatcher

+ ( NSArray< THXXcodeMessageMatcher * > * )defaultMessageMatchers;
{
    return @[
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionAnalyzeMatcher              status: SKStatusIdea    resultFormat: @"Analyzing $(yellow)$(2)$(clear)" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionBuildTargetMatcher          status: SKStatusTarget  resultFormat: @"Building target $(purple)$(1)$(clear) - $(blue)$(3)$(clear)" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionAggregateTargetMatcher      status: SKStatusTarget  resultFormat: @"Building aggregate target $(purple)$(1)$(clear) - $(blue)$(3)$(clear)" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionAnalyzeTargetMatcher        status: SKStatusTarget  resultFormat: @"Analyzing target $(purple)$(1)$(clear) - $(blue)$(3)$(clear)" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionCheckDependenciesMatcher    status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionShellCommandMatcher         status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionCleanRemoveMatcher          status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionCleanTargetMatcher          status: SKStatusTarget  resultFormat: @"Cleaning target $(purple)$(1)$(clear) - $(blue)$(3)$(clear)" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionCodesignMatcher             status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionCodesignFrameworkMatcher    status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionCompileMatcher              status: SKStatusBuild   resultFormat: @"Compiling $(yellow)$(2)$(clear)" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionCompileCommandMatcher       status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionCompileXIBMatcher           status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionCompileStoryboardMatcher    status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionCopyHeaderMatcher           status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionCopyPlistMatcher            status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionCopyStringsMatcher          status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionCpresourceMatcher           status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionExecutedMatcher             status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionFailingTestMatcher          status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionUiFailingTestMatcher        status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionGenerateDsymMatcher         status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionLibtoolMatcher              status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionLinkingMatcher              status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionTestCasePassedMatcher       status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionTestCaseStartedMatcher      status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionTestCasePendingMatcher      status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionTestCaseMeasuredMatcher     status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionPhaseSuccessMatcher         status: SKStatusSuccess resultFormat: @"$(green)$(1) succeeded$(clear)" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionPhaseScriptExecutionMatcher status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionProcessPCHMatcher           status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionProcessPCHCommandMatcher    status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionPreprocessMatcher           status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionPBXCPMatcher                status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionProcessInfoPlistMatcher     status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionTestsRunCompletionMatcher   status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionTestSuiteStartedMatcher     status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionTestSuiteStartMatcher       status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionTiffutilMatcher             status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionTouchMatcher                status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionWriteFileMatcher            status: SKStatusNone    resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionWriteAuxiliaryFiles         status: SKStatusNone    resultFormat: @"" ]
    ];
}

+ ( NSArray< THXXcodeMessageMatcher * > * )defaultWarningMatchers;
{
    return @[
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionCompileWarningMatcher       status: SKStatusWarning resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionLDWarningMatcher            status: SKStatusWarning resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionGenericWarningMatcher       status: SKStatusWarning resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionWillNotBeCodeSignedMatcher  status: SKStatusWarning resultFormat: @"" ]
    ];
}

+ ( NSArray< THXXcodeMessageMatcher * > * )defaultErrorMatchers
{
    return @[
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionClangErrorMatcher                       status: SKStatusError resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionCheckDependenciesErrorsMatcher          status: SKStatusError resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionProvisioningProfileRequiredMatcher      status: SKStatusError resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionNoCertificateMatcher                    status: SKStatusError resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionCompileErrorMatcher                     status: SKStatusError resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionCursorMatcher                           status: SKStatusError resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionFatalErrorMatcher                       status: SKStatusError resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionFileMissingErrorMatcher                 status: SKStatusError resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionLDErrorMatcher                          status: SKStatusError resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionLinkerDuplicateSymbolsLocationMatcher   status: SKStatusError resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionLinkerDuplicateSymbolsMatcher           status: SKStatusError resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionLinkerUndefinedSymbolLocationMatcher    status: SKStatusError resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionLinkerUndefinedSymbolsMatcher           status: SKStatusError resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionPodsErrorMatcher                        status: SKStatusError resultFormat: @"" ],
        [ THXXcodeMessageMatcher matcherWithExpression: THXRegularExpressionSymbolReferencedFromMatcher             status: SKStatusError resultFormat: @"" ]
    ];
}

+ ( instancetype )matcherWithExpression: ( NSString * )expr resultFormat: ( NSString * )format
{
    return [ [ self alloc ] initWithExpression: expr resultFormat: format ];
}

+ ( instancetype )matcherWithExpression: ( NSString * )expr status: ( SKStatus )status resultFormat: ( NSString * )format
{
    return [ [ self alloc ] initWithExpression: expr status: status resultFormat: format ];
}

- ( instancetype )init
{
    return [ self initWithExpression: @"" status: SKStatusNone resultFormat: @"" ];
}

- ( instancetype )initWithExpression: ( NSString * )expr resultFormat: ( NSString * )format
{
    return [ self initWithExpression: expr status: SKStatusNone resultFormat: format ];
}

- ( instancetype )initWithExpression: ( NSString * )expr status: ( SKStatus )status resultFormat: ( NSString * )format
{
    NSError * error;
    
    if( ( self = [ super init ] ) )
    {
        self.expression        = expr;
        self.resultFormat      = format;
        self.status            = status;
        self.regularExpression = [ NSRegularExpression regularExpressionWithPattern: self.expression options: ( NSRegularExpressionOptions )0 error: &error ];
        
        if( error != nil )
        {
            @throw [ NSException exceptionWithName: @"com.xs-labs.thx.THXXcodeMessageMatcherException" reason: error.description userInfo: nil ];
        }
    }
    
    return self;
}

@end
