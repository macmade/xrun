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
 * @file        XRRegularExpressions.m
 * @copyright   (c) 2017, Jean-David Gadina - www.xs-labs.com
 */

#import "XRRegularExpressions.h"

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

/*
 * Captured groups:
 * - 1: file path
 * - 2: file name
 */
NSString * const XRRegularExpressionAnalyzeMatcher = @"Analyze(?:Shallow)?\\s(.*\\/(.*\\.(?:m|mm|cc|cpp|c|cxx)))\\s*";

/*
 * Captured groups:
 * - 1: target
 * - 2: project
 * - 3: configuration
 */
NSString * const XRRegularExpressionBuildTargetMatcher = @"=== BUILD TARGET\\s(.*)\\sOF PROJECT\\s(.*)\\sWITH.*CONFIGURATION\\s(.*)\\s===";

/*
 * Captured groups:
 * - 1: target
 * - 2: project
 * - 3: configuration
 */
NSString * const XRRegularExpressionAggregateTargetMatcher = @"=== BUILD AGGREGATE TARGET\\s(.*)\\sOF PROJECT\\s(.*)\\sWITH.*CONFIGURATION\\s(.*)\\s===";

/*
 * Captured groups:
 * - 1: target
 * - 2: project
 * - 3: configuration
 */
NSString * const XRRegularExpressionAnalyzeTargetMatcher = @"=== ANALYZE TARGET\\s(.*)\\sOF PROJECT\\s(.*)\\sWITH.*CONFIGURATION\\s(.*)\\s===";

/*
 * Captured groups: none
 */
NSString * const XRRegularExpressionCheckDependenciesMatcher = @"Check dependencies";

/*
 * Captured groups:
 * - 1: command path
 * - 2: arguments
 */
NSString * const XRRegularExpressionShellCommandMatcher = @"\\s{4}(cd|setenv|(?:[\\w\\/:\\\\\\s\\-.]+?\\/)?[\\w\\-]+)\\s(.*)$";

/*
 * Captured groups: none
 */
NSString * const XRRegularExpressionCleanRemoveMatcher = @"Clean.Remove";

/*
 * Captured groups:
 * - 1: target
 * - 2: project
 * - 3: configuration
 */
NSString * const XRRegularExpressionCleanTargetMatcher = @"=== CLEAN TARGET\\s(.*)\\sOF PROJECT\\s(.*)\\sWITH CONFIGURATION\\s(.*)\\s===";

/*
 * Captured groups:
 * - 1: file
 */
NSString * const XRRegularExpressionCodesignMatcher = @"CodeSign\\s((?:\\\\ |[^ ])*)$";

/*
 * Captured groups:
 * - 1: file
 */
NSString * const XRRegularExpressionCodesignFrameworkMatcher = @"CodeSign\\s((?:\\\\ |[^ ])*.framework)\\/Versions";

/*
 * Captured groups:
 * - 1: file path
 * - 2: file name
 */
NSString * const XRRegularExpressionCompileMatcher = @"Compile[\\w]+\\s.+?\\s((?:\\\\.|[^ ])+\\/((?:\\\\.|[^ ])+\\.(?:m|mm|c|cc|cpp|cxx|swift)))\\s.*";

/*
 * Captured groups:
 * - 1: compiler command
 * - 2: file path
 */
NSString * const XRRegularExpressionCompileCommandMatcher = @"\\s*(.*\\/bin\\/clang\\s.*\\s\\-c\\s(.*\\.(?:m|mm|c|cc|cpp|cxx))\\s.*\\.o)$";

/*
 * Captured groups:
 * - 1: file path
 * - 2: file name
 */
NSString * const XRRegularExpressionCompileXIBMatcher = @"CompileXIB\\s(.*\\/(.*\\.xib))";

/*
 * Captured groups:
 * - 1: file path
 * - 2: file name
 */
NSString * const XRRegularExpressionCompileStoryboardMatcher = @"CompileStoryboard\\s(.*\\/([^\\/].*\\.storyboard))";

/*
 * Captured groups:
 * - 1: source file
 * - 2: target file
 */
NSString * const XRRegularExpressionCopyHeaderMatcher = @"CpHeader\\s(.*\\.h)\\s(.*\\.h)";

/*
 * Captured groups:
 * - 1: source file
 * - 2: target file
 */
NSString * const XRRegularExpressionCopyPlistMatcher = @"CopyPlistFile\\s(.*\\.plist)\\s(.*\\.plist)";

/*
 * Captured groups:
 * - 1: file
 */
NSString * const XRRegularExpressionCopyStringsMatcher = @"CopyStringsFile.*\\/(.*.strings)";

/*
 * Captured groups:
 * - 1: resource
 */
NSString * const XRRegularExpressionCpresourceMatcher = @"CpResource\\s(.*)\\s\\/";

/*
 * Captured groups: none
 */
NSString * const XRRegularExpressionExecutedMatcher = @"\\s*Executed";

/*
 * Captured groups:
 * - 1: file
 * - 2: test suite
 * - 3: test case
 * - 4: reason
 */
NSString * const XRRegularExpressionFailingTestMatcher = @"\\s*(.+:\\d+):\\serror:\\s[\\+\\-]\\[(.*)\\s(.*)\\]\\s:(?:\\s'.*'\\s\\[FAILED\\],)?\\s(.*)";

/*
 * Captured groups:
 * - 1: file
 * - 2: reason
 */
NSString * const XRRegularExpressionUiFailingTestMatcher = @"\\s{4}t = \\s+\\d+\\.\\d+s\\s+Assertion Failure: (.*:\\d+): (.*)$";

/*
 * Captured groups:
 * - 1: dsym
 */
NSString * const XRRegularExpressionGenerateDsymMatcher = @"GenerateDSYMFile \\/.*\\/(.*\\.dSYM)";

/*
 * Captured groups:
 * - 1: library
 */
NSString * const XRRegularExpressionLibtoolMatcher = @"Libtool.*\\/(.*\\.a)";

/*
 * Captured groups:
 * - 1: target
 * - 2: build variants
 * - 3: architecture
 */
NSString * const XRRegularExpressionLinkingMatcher = @"Ld \\/?.*\\/(.*?) (.*) (.*)$";

/*
 * Captured groups:
 * - 1: suite
 * - 2: test case
 * - 3: time
 */
NSString * const XRRegularExpressionTestCasePassedMatcher = @"\\s*Test Case\\s'-\\[(.*)\\s(.*)\\]'\\spassed\\s\\((\\d*\\.\\d{3})\\sseconds\\)";

/*
 * Captured groups:
 * - 1: suite
 * - 2: test case
 */
NSString * const XRRegularExpressionTestCaseStartedMatcher = @"Test Case '-\\[(.*) (.*)\\]' started.$";

/*
 * Captured groups:
 * - 1: suite
 * - 2: test case
 */
NSString * const XRRegularExpressionTestCasePendingMatcher = @"Test Case\\s'-\\[(.*)\\s(.*)PENDING\\]'\\spassed";

/*
 * Captured groups:
 * - 1: suite
 * - 2: test case
 * - 3: time
 */
NSString * const XRRegularExpressionTestCaseMeasuredMatcher = @"[^:]*:[^:]*:\\sTest Case\\s'-\\[(.*)\\s(.*)\\]'\\smeasured\\s\\[Time,\\sseconds\\]\\saverage:\\s(\\d*\\.\\d{3}),";

/*
 * Captured groups:
 * - 1: phase
 */
NSString * const XRRegularExpressionPhaseSuccessMatcher = @"\\*\\*\\s(.*)\\sSUCCEEDED\\s\\*\\*";

/*
 * Captured groups:
 * - 1: script name
 */
NSString * const XRRegularExpressionPhaseScriptExecutionMatcher = @"PhaseScriptExecution\\s((\\\\\\ |\\S)*)\\s";

/*
 * Captured groups:
 * - 1: file
 */
NSString * const XRRegularExpressionProcessPCHMatcher = @"ProcessPCH\\s.*\\s(.*.pch)";

/*
 * Captured groups:
 * - 1: file path
 */
NSString * const XRRegularExpressionProcessPCHCommandMatcher = @"\\s*.*\\/usr\\/bin\\/clang\\s.*\\s\\-c\\s(.*)\\s\\-o\\s.*";

/*
 * Captured groups:
 * - 1: file
 */
NSString * const XRRegularExpressionPreprocessMatcher = @"Preprocess\\s(?:(?:\\\\ |[^ ])*)\\s((?:\\\\ |[^ ])*)$";

/*
 * Captured groups:
 * - 1: file
 */
NSString * const XRRegularExpressionPBXCPMatcher = @"PBXCp\\s((?:\\\\ |[^ ])*)";

/*
 * Captured groups:
 * - 1: file
 */
NSString * const XRRegularExpressionProcessInfoPlistMatcher = @"ProcessInfoPlistFile\\s.*\\.plist\\s(.*\\/+(.*\\.plist))";

/*
 * Captured groups:
 * - 1: suite
 * - 2: time
 */
NSString * const XRRegularExpressionTestsRunCompletionMatcher = @"\\s*Test Suite '(?:.*\\/)?(.*[ox]ctest.*)' (finished|passed|failed) at (.*)";

/*
 * Captured groups:
 * - 1: suite
 * - 2: time
 */
NSString * const XRRegularExpressionTestSuiteStartedMatcher = @"\\s*Test Suite '(?:.*\\/)?(.*[ox]ctest.*)' started at(.*)";

/*
 * Captured groups:
 * - 1: test suite name
 */
NSString * const XRRegularExpressionTestSuiteStartMatcher = @"\\s*Test Suite '(.*)' started at";

/*
 * Captured groups:
 * - 1: file name
 */
NSString * const XRRegularExpressionTiffutilMatcher = @"TiffUtil\\s(.*)";

/*
 * Captured groups:
 * - 1: file path
 * - 2: file name
 */
NSString * const XRRegularExpressionTouchMatcher = @"Touch\\s(.*\\/(.+))";

/*
 * Captured groups:
 * - 1: file path
 */
NSString * const XRRegularExpressionWriteFileMatcher = @"write-file\\s(.*)";

/*
 * Captured groups: none
 */
NSString * const XRRegularExpressionWriteAuxiliaryFiles = @"Write auxiliary files";

/*******************************************************************************
 * WARNINGS
 ******************************************************************************/

/*
 * Captured groups:
 * - 1: file path
 * - 2: file name
 * - 3: reason
 */
NSString * const XRRegularExpressionCompileWarningMatcher = @"(\\/.+\\/(.*):.*:.*):\\swarning:\\s(.*)$";

/*
 * Captured groups:
 * - 1: ld prefix
 * - 2: warning message
 */
NSString * const XRRegularExpressionLDWarningMatcher = @"(ld: )warning: (.*)";

/*
 * Captured groups:
 * - 1: whole warning
 */
NSString * const XRRegularExpressionGenericWarningMatcher = @"warning:\\s(.*)$";

/*
 * Captured groups:
 * - 1: whole warning
 */
NSString * const XRRegularExpressionWillNotBeCodeSignedMatcher = @"(.* will not be code signed because .*)$";

/*******************************************************************************
 * ERRORS
 ******************************************************************************/

/*
 * Captured groups:
 * - 1: whole error
 */
NSString * const XRRegularExpressionClangErrorMatcher = @"(clang: error:.*)$";

/*
 * Captured groups:
 * - 1: whole error
 */
NSString * const XRRegularExpressionCheckDependenciesErrorsMatcher = @"(Code\\s?Sign error:.*|Code signing is required for product type .* in SDK .*|No profile matching .* found:.*|Provisioning profile .* doesn't .*|Swift is unavailable on .*|.?Use Legacy Swift Language Version.*)$";

/*
 * Captured groups:
 * - 1: whole error
 */
NSString * const XRRegularExpressionProvisioningProfileRequiredMatcher = @"(.*requires a provisioning profile.*)$";

/*
 * Captured groups:
 * - 1: whole error
 */
NSString * const XRRegularExpressionNoCertificateMatcher = @"(No certificate matching.*)$";

/*
 * Captured groups:
 * - 1: file path
 * - 2: file name
 * - 3: reason
 */
NSString * const XRRegularExpressionCompileErrorMatcher = @"(\\/.+\\/(.*):.*:.*):\\s(?:fatal\\s)?error:\\s(.*)$";

/*
 * Captured groups:
 * - 1: cursor
 */
NSString * const XRRegularExpressionCursorMatcher = @"([\\s~]*\\^[\\s~]*)$";

/*
 * Captured groups:
 * - 1: whole error
*/
NSString * const XRRegularExpressionFatalErrorMatcher = @"(fatal error:.*)$";

/*
 * Captured groups:
 * - 1: whole error.
 * - 2: file path
 */
NSString * const XRRegularExpressionFileMissingErrorMatcher = @"<unknown>:0:\\s(error:\\s.*)\\s'(\\/.+\\/.*\\..*)'$";

/*
 * Captured groups:
 * - 1: whole error
 */
NSString * const XRRegularExpressionLDErrorMatcher = @"(ld:.*)";

/*
 * Captured groups:
 * - 1: file path
 */
NSString * const XRRegularExpressionLinkerDuplicateSymbolsLocationMatcher = @"\\s+(\\/.*\\.o[\\)]?)$";

/*
 * Captured groups:
 * - 1: reason
 */
NSString * const XRRegularExpressionLinkerDuplicateSymbolsMatcher = @"(duplicate symbol .*):$";

/*
 * Captured groups:
 * - 1: symbol location
 */
NSString * const XRRegularExpressionLinkerUndefinedSymbolLocationMatcher = @"(.* in .*\\.o)$";

/*
 * Captured groups:
 * - 1: reason
 */
NSString * const XRRegularExpressionLinkerUndefinedSymbolsMatcher = @"(Undefined symbols for architecture .*):$";

/*
 * Captured groups:
 * - 1: reason
 */
NSString * const XRRegularExpressionPodsErrorMatcher = @"(error:\\s.*)";

/*
 * Captured groups:
 * - 1: reference
 */
NSString * const XRRegularExpressionSymbolReferencedFromMatcher = @"\\s+\"(.*)\", referenced from:$";
