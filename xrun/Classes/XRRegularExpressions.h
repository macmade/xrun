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
 * @header      XRRegularExpressions.h
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

FOUNDATION_EXPORT NSString * const XRRegularExpressionAnalyzeMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionBuildTargetMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionAggregateTargetMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionAnalyzeTargetMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionCheckDependenciesMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionCleanRemoveMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionCleanTargetMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionCodesignMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionCodesignFrameworkMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionCompileMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionCompileXIBMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionCompileStoryboardMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionCopyHeaderMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionCopyPlistMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionCopyStringsMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionCpresourceMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionExecutedMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionFailingTestMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionUiFailingTestMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionGenerateDsymMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionLibtoolMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionLinkingMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionTestCasePassedMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionTestCaseStartedMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionTestCasePendingMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionTestCaseMeasuredMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionPhaseSuccessMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionPhaseScriptExecutionMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionProcessPCHMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionProcessPCHCommandMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionPreprocessMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionPBXCPMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionProcessInfoPlistMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionTestsRunCompletionMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionTestSuiteStartedMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionTestSuiteStartMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionTiffutilMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionTouchMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionWriteFileMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionWriteAuxiliaryFiles;

/*******************************************************************************
 * ANALYZER WARNINGS
 ******************************************************************************/

FOUNDATION_EXPORT NSString * const XRRegularExpressionAnalyzerWarningMatcher;

/*******************************************************************************
 * WARNINGS
 ******************************************************************************/

FOUNDATION_EXPORT NSString * const XRRegularExpressionCompileWarningMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionLDWarningMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionGenericWarningMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionWillNotBeCodeSignedMatcher;

/*******************************************************************************
 * ERRORS
 ******************************************************************************/

FOUNDATION_EXPORT NSString * const XRRegularExpressionPhaseFailedMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionClangErrorMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionCheckDependenciesErrorsMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionProvisioningProfileRequiredMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionNoCertificateMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionCompileErrorMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionCursorMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionFatalErrorMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionFileMissingErrorMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionLDErrorMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionLinkerDuplicateSymbolsLocationMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionLinkerDuplicateSymbolsMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionLinkerUndefinedSymbolLocationMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionLinkerUndefinedSymbolsMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionPodsErrorMatcher;
FOUNDATION_EXPORT NSString * const XRRegularExpressionSymbolReferencedFromMatcher;
