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
 * @file        XRXcodeMessageMatcher.m
 * @copyright   (c) 2017, Jean-David Gadina - www.xs-labs.com
 */

#import "XRXcodeMessageMatcher.h"
#import "XRRegularExpressions.h"

NS_ASSUME_NONNULL_BEGIN

@interface XRXcodeMessageMatcher()

@property( atomic, readwrite, strong ) NSString            * expression;
@property( atomic, readwrite, strong ) NSRegularExpression * regularExpression;
@property( atomic, readwrite, strong ) NSString            * resultFormat;
@property( atomic, readwrite, assign ) SKStatus              status;

@end

NS_ASSUME_NONNULL_END

@implementation XRXcodeMessageMatcher

+ ( NSArray< XRXcodeMessageMatcher * > * )defaultMessageMatchers;
{
    return @[
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionAnalyzeMatcher              status: SKStatusIdea    resultFormat: @"Analyzing $(yellow)$(2)$(clear)" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionBuildTargetMatcher          status: SKStatusTarget  resultFormat: @"Building target $(purple)$(1)$(clear) - $(blue)$(3)$(clear)" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionAggregateTargetMatcher      status: SKStatusTarget  resultFormat: @"Building aggregate target $(purple)$(1)$(clear) - $(blue)$(3)$(clear)" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionAnalyzeTargetMatcher        status: SKStatusTarget  resultFormat: @"Analyzing target $(purple)$(1)$(clear) - $(blue)$(3)$(clear)" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCheckDependenciesMatcher    status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionShellCommandMatcher         status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCleanRemoveMatcher          status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCleanTargetMatcher          status: SKStatusTarget  resultFormat: @"Cleaning target $(purple)$(1)$(clear) - $(blue)$(3)$(clear)" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCodesignMatcher             status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCodesignFrameworkMatcher    status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCompileMatcher              status: SKStatusBuild   resultFormat: @"Compiling $(yellow)$(2)$(clear)" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCompileCommandMatcher       status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCompileXIBMatcher           status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCompileStoryboardMatcher    status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCopyHeaderMatcher           status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCopyPlistMatcher            status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCopyStringsMatcher          status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCpresourceMatcher           status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionExecutedMatcher             status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionFailingTestMatcher          status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionUiFailingTestMatcher        status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionGenerateDsymMatcher         status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionLibtoolMatcher              status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionLinkingMatcher              status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionTestCasePassedMatcher       status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionTestCaseStartedMatcher      status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionTestCasePendingMatcher      status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionTestCaseMeasuredMatcher     status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionPhaseSuccessMatcher         status: SKStatusSuccess resultFormat: @"$(green)$(1) succeeded$(clear)" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionPhaseScriptExecutionMatcher status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionProcessPCHMatcher           status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionProcessPCHCommandMatcher    status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionPreprocessMatcher           status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionPBXCPMatcher                status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionProcessInfoPlistMatcher     status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionTestsRunCompletionMatcher   status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionTestSuiteStartedMatcher     status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionTestSuiteStartMatcher       status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionTiffutilMatcher             status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionTouchMatcher                status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionWriteFileMatcher            status: SKStatusNone    resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionWriteAuxiliaryFiles         status: SKStatusNone    resultFormat: @"" ]
    ];
}

+ ( NSArray< XRXcodeMessageMatcher * > * )defaultWarningMatchers;
{
    return @[
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCompileWarningMatcher       status: SKStatusWarning resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionLDWarningMatcher            status: SKStatusWarning resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionGenericWarningMatcher       status: SKStatusWarning resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionWillNotBeCodeSignedMatcher  status: SKStatusWarning resultFormat: @"" ]
    ];
}

+ ( NSArray< XRXcodeMessageMatcher * > * )defaultErrorMatchers
{
    return @[
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionClangErrorMatcher                       status: SKStatusError resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCheckDependenciesErrorsMatcher          status: SKStatusError resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionProvisioningProfileRequiredMatcher      status: SKStatusError resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionNoCertificateMatcher                    status: SKStatusError resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCompileErrorMatcher                     status: SKStatusError resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCursorMatcher                           status: SKStatusError resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionFatalErrorMatcher                       status: SKStatusError resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionFileMissingErrorMatcher                 status: SKStatusError resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionLDErrorMatcher                          status: SKStatusError resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionLinkerDuplicateSymbolsLocationMatcher   status: SKStatusError resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionLinkerDuplicateSymbolsMatcher           status: SKStatusError resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionLinkerUndefinedSymbolLocationMatcher    status: SKStatusError resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionLinkerUndefinedSymbolsMatcher           status: SKStatusError resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionPodsErrorMatcher                        status: SKStatusError resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionSymbolReferencedFromMatcher             status: SKStatusError resultFormat: @"" ]
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
            @throw [ NSException exceptionWithName: @"com.xs-labs.Xrun.XRXcodeMessageMatcherException" reason: error.description userInfo: nil ];
        }
    }
    
    return self;
}

@end
