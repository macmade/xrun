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
 * @header      THXRegularExpressions.h
 * @copyright   (c) 2017, Jean-David Gadina - www.xs-labs.com
 */

#import <Foundation/Foundation.h>

/*******************************************************************************
 * Copyright Notice
 * 
 * The following regular expressions have been borrowed from the xcpretty
 * project, by Marin Usalj.
 * 
 * xcpretty is released under the terms of the MIT license:
 * 
 *  - https://opensource.org/licenses/MIT
 * 
 * Copyright (c) 2013-2016 Marin Usalj
 * 
 *  - https://github.com/supermarin/xcpretty
 *  - http://supermar.in
 ******************************************************************************/

FOUNDATION_EXPORT NSString * const THXRegularExpressionAnalyzeMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionBuildTargetMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionAggregateTargetMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionAnalyzeTargetMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionCheckDependenciesMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionShellCommandMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionCleanRemoveMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionCleanTargetMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionCodesignMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionCodesignFrameworkMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionCompileMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionCompileCommandMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionCompileXIBMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionCompileStoryboardMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionCopyHeaderMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionCopyPlistMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionCopyStringsMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionCpresourceMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionExecutedMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionFailingTestMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionUiFailingTestMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionGenerateDsymMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionLibtoolMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionLinkingMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionTestCasePassedMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionTestCaseStartedMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionTestCasePendingMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionTestCaseMeasuredMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionPhaseSuccessMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionPhaseScriptExecutionMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionProcessPCHMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionProcessPCHCommandMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionPreprocessMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionPBXCPMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionProcessInfoPlistMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionTestsRunCompletionMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionTestSuiteStartedMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionTestSuiteStartMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionTiffutilMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionTouchMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionWriteFileMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionWriteAuxiliaryFiles;

/*******************************************************************************
 * WARNINGS
 ******************************************************************************/

FOUNDATION_EXPORT NSString * const THXRegularExpressionCompileWarningMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionLDWarningMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionGenericWarningMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionWillNotBeCodeSignedMatcher;

/*******************************************************************************
 * ERRORS
 ******************************************************************************/

FOUNDATION_EXPORT NSString * const THXRegularExpressionClangErrorMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionCheckDependenciesErrorsMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionProvisioningProfileRequiredMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionNoCertificateMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionCompileErrorMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionCursorMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionFatalErrorMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionFileMissingErrorMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionLDErrorMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionLinkerDuplicateSymbolsLocationMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionLinkerDuplicateSymbolsMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionLinkerUndefinedSymbolLocationMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionLinkerUndefinedSymbolsMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionPodsErrorMatcher;
FOUNDATION_EXPORT NSString * const THXRegularExpressionSymbolReferencedFromMatcher;
