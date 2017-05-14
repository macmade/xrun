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
@property( atomic, readwrite, assign ) BOOL                  verbose;

@end

NS_ASSUME_NONNULL_END

@implementation XRXcodeMessageMatcher

+ ( NSArray< XRXcodeMessageMatcher * > * )defaultMessageMatchers;
{
    //char * s = NULL;
    //*( s )   = 0;
    
    return @[
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionAnalyzeMatcher              verbose: NO  status: SKStatusIdea      resultFormat: @"Analyzing $(yellow)$(2)$(clear)" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionBuildTargetMatcher          verbose: NO  status: SKStatusTarget    resultFormat: @"Building target $(purple)$(1)$(clear) - $(blue)$(3)$(clear)" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionAggregateTargetMatcher      verbose: NO  status: SKStatusTarget    resultFormat: @"Building aggregate target $(purple)$(1)$(clear) - $(blue)$(3)$(clear)" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionAnalyzeTargetMatcher        verbose: NO  status: SKStatusTarget    resultFormat: @"Analyzing target $(purple)$(1)$(clear) - $(blue)$(3)$(clear)" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCheckDependenciesMatcher    verbose: NO  status: SKStatusNone      resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionShellCommandMatcher         verbose: NO  status: SKStatusNone      resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCleanRemoveMatcher          verbose: YES status: SKStatusTrash     resultFormat: @"Removing $(yellow)$(2)$(clear)" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCleanTargetMatcher          verbose: NO  status: SKStatusTarget    resultFormat: @"Cleaning target $(purple)$(1)$(clear) - $(blue)$(3)$(clear)" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCodesignMatcher             verbose: NO  status: SKStatusSecurity  resultFormat: @"Code signing $(purple)$(2)$(clear)" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCodesignFrameworkMatcher    verbose: NO  status: SKStatusSecurity  resultFormat: @"Code signing $(purple)$(2)$(clear)" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCompileMatcher              verbose: NO  status: SKStatusBuild     resultFormat: @"Compiling $(yellow)$(2)$(clear)" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCompileCommandMatcher       verbose: NO  status: SKStatusNone      resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCompileXIBMatcher           verbose: NO  status: SKStatusNone      resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCompileStoryboardMatcher    verbose: NO  status: SKStatusNone      resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCopyHeaderMatcher           verbose: NO  status: SKStatusNone      resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCopyPlistMatcher            verbose: NO  status: SKStatusNone      resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCopyStringsMatcher          verbose: NO  status: SKStatusNone      resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCpresourceMatcher           verbose: NO  status: SKStatusNone      resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionExecutedMatcher             verbose: NO  status: SKStatusNone      resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionFailingTestMatcher          verbose: NO  status: SKStatusNone      resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionUiFailingTestMatcher        verbose: NO  status: SKStatusNone      resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionGenerateDsymMatcher         verbose: NO  status: SKStatusNone      resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionLibtoolMatcher              verbose: NO  status: SKStatusNone      resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionLinkingMatcher              verbose: NO  status: SKStatusLink      resultFormat: @"Linking $(purple)$(1)$(clear) - $(blue)$(2) $(3)$(clear)" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionTestCasePassedMatcher       verbose: NO  status: SKStatusNone      resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionTestCaseStartedMatcher      verbose: NO  status: SKStatusNone      resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionTestCasePendingMatcher      verbose: NO  status: SKStatusNone      resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionTestCaseMeasuredMatcher     verbose: NO  status: SKStatusNone      resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionPhaseSuccessMatcher         verbose: NO  status: SKStatusSuccess   resultFormat: @"$(green)$(1) succeeded$(clear)" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionPhaseScriptExecutionMatcher verbose: NO  status: SKStatusNone      resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionProcessPCHMatcher           verbose: NO  status: SKStatusNone      resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionProcessPCHCommandMatcher    verbose: NO  status: SKStatusNone      resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionPreprocessMatcher           verbose: NO  status: SKStatusNone      resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionPBXCPMatcher                verbose: NO  status: SKStatusNone      resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionProcessInfoPlistMatcher     verbose: NO  status: SKStatusNone      resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionTestsRunCompletionMatcher   verbose: NO  status: SKStatusNone      resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionTestSuiteStartedMatcher     verbose: NO  status: SKStatusNone      resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionTestSuiteStartMatcher       verbose: NO  status: SKStatusNone      resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionTiffutilMatcher             verbose: NO  status: SKStatusNone      resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionTouchMatcher                verbose: NO  status: SKStatusNone      resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionWriteFileMatcher            verbose: YES status: SKStatusFile      resultFormat: @"Writing file $(yellow)$(2)$(clear)" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionWriteAuxiliaryFiles         verbose: YES status: SKStatusFolder    resultFormat: @"Writing auxiliary files" ]
    ];
}

+ ( NSArray< XRXcodeMessageMatcher * > * )defaultWarningMatchers;
{
    return @[
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCompileWarningMatcher       verbose: NO  status: SKStatusWarning resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionLDWarningMatcher            verbose: NO  status: SKStatusWarning resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionGenericWarningMatcher       verbose: NO  status: SKStatusWarning resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionWillNotBeCodeSignedMatcher  verbose: NO  status: SKStatusWarning resultFormat: @"" ]
    ];
}

+ ( NSArray< XRXcodeMessageMatcher * > * )defaultErrorMatchers
{
    return @[
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionPhaseFailedMatcher                      verbose: NO  status: SKStatusError resultFormat: @"$(red)$(1) failed$(clear)" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionClangErrorMatcher                       verbose: NO  status: SKStatusError resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCheckDependenciesErrorsMatcher          verbose: NO  status: SKStatusError resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionProvisioningProfileRequiredMatcher      verbose: NO  status: SKStatusError resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionNoCertificateMatcher                    verbose: NO  status: SKStatusError resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCompileErrorMatcher                     verbose: NO  status: SKStatusError resultFormat: @"$(yellow)$(2)$(clear): $(red)$(3)$(clear)" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionCursorMatcher                           verbose: NO  status: SKStatusError resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionFatalErrorMatcher                       verbose: NO  status: SKStatusError resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionFileMissingErrorMatcher                 verbose: NO  status: SKStatusError resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionLDErrorMatcher                          verbose: NO  status: SKStatusError resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionLinkerDuplicateSymbolsLocationMatcher   verbose: NO  status: SKStatusError resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionLinkerDuplicateSymbolsMatcher           verbose: NO  status: SKStatusError resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionLinkerUndefinedSymbolLocationMatcher    verbose: NO  status: SKStatusError resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionLinkerUndefinedSymbolsMatcher           verbose: NO  status: SKStatusError resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionPodsErrorMatcher                        verbose: NO  status: SKStatusError resultFormat: @"" ],
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionSymbolReferencedFromMatcher             verbose: NO  status: SKStatusError resultFormat: @"" ]
    ];
}

+ ( NSArray< XRXcodeMessageMatcher * > * )defaultAnalyzerMatchers
{
    return @[
        [ XRXcodeMessageMatcher matcherWithExpression: XRRegularExpressionAnalyzerWarningMatcher verbose: NO status: SKStatusError resultFormat: @"$(yellow)$(2):$(3):$(4):$(clear) $(red)$(5)$(clear)" ],
    ];
}

+ ( instancetype )matcherWithExpression: ( NSString * )expr verbose: ( BOOL )verbose status: ( SKStatus )status resultFormat: ( NSString * )format
{
    return [ [ self alloc ] initWithExpression: expr verbose: verbose status: status resultFormat: format ];
}

- ( instancetype )init
{
    return [ self initWithExpression: @"" verbose: NO status: SKStatusNone resultFormat: @"" ];
}

- ( instancetype )initWithExpression: ( NSString * )expr verbose: ( BOOL )verbose status: ( SKStatus )status resultFormat: ( NSString * )format
{
    NSError * error;
    
    if( ( self = [ super init ] ) )
    {
        self.expression        = expr;
        self.resultFormat      = format;
        self.status            = status;
        self.verbose           = verbose;
        self.regularExpression = [ NSRegularExpression regularExpressionWithPattern: self.expression options: NSRegularExpressionAnchorsMatchLines error: &error ];
        
        if( error != nil )
        {
            @throw [ NSException exceptionWithName: @"com.xs-labs.Xrun.XRXcodeMessageMatcherException" reason: error.description userInfo: nil ];
        }
    }
    
    return self;
}

@end
