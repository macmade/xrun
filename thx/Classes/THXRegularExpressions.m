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
 * @file        THXRegularExpressions.m
 * @copyright   (c) 2017, Jean-David Gadina - www.xs-labs.com
 */

#import "THXRegularExpressions.h"

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
NSString * const THXRegularExpressionAnalyzeMatcher = @"Analyze(?:Shallow)?\\s(.*\\/(.*\\.(?:m|mm|cc|cpp|c|cxx)))\\s*";

/*
 * Captured groups:
 * - 1: target
 * - 2: project
 * - 3: configuration
 */
NSString * const THXRegularExpressionBuildTargetMatcher = @"=== BUILD TARGET\\s(.*)\\sOF PROJECT\\s(.*)\\sWITH.*CONFIGURATION\\s(.*)\\s===";

/*
 * Captured groups:
 * - 1: target
 * - 2: project
 * - 3: configuration
 */
NSString * const THXRegularExpressionAggregateTargetMatcher = @"=== BUILD AGGREGATE TARGET\\s(.*)\\sOF PROJECT\\s(.*)\\sWITH.*CONFIGURATION\\s(.*)\\s===";

/*
 * Captured groups:
 * - 1: target
 * - 2: project
 * - 3: configuration
 */
NSString * const THXRegularExpressionAnalyzeTargetMatcher = @"=== ANALYZE TARGET\\s(.*)\\sOF PROJECT\\s(.*)\\sWITH.*CONFIGURATION\\s(.*)\\s===";

/*
 * Captured groups: none
 */
NSString * const THXRegularExpressionCheckDependenciesMatcher = @"Check dependencies";

/*
 * Captured groups:
 * - 1: command path
 * - 2: arguments
 */
NSString * const THXRegularExpressionShellCommandMatcher = @"\\s{4}(cd|setenv|(?:[\\w\\/:\\\\\\s\\-.]+?\\/)?[\\w\\-]+)\\s(.*)$";

/*
 * Captured groups: none
 */
NSString * const THXRegularExpressionCleanRemoveMatcher = @"Clean.Remove";

/*
 * Captured groups:
 * - 1: target
 * - 2: project
 * - 3: configuration
 */
NSString * const THXRegularExpressionCleanTargetMatcher = @"=== CLEAN TARGET\\s(.*)\\sOF PROJECT\\s(.*)\\sWITH CONFIGURATION\\s(.*)\\s===";

/*
 * Captured groups:
 * - 1: file
 */
NSString * const THXRegularExpressionCodesignMatcher = @"CodeSign\\s((?:\\\\ |[^ ])*)$";

/*
 * Captured groups:
 * - 1: file
 */
NSString * const THXRegularExpressionCodesignFrameworkMatcher = @"CodeSign\\s((?:\\\\ |[^ ])*.framework)\\/Versions";

/*
 * Captured groups:
 * - 1: file path
 * - 2: file name
 */
NSString * const THXRegularExpressionCompileMatcher = @"Compile[\\w]+\\s.+?\\s((?:\\\\.|[^ ])+\\/((?:\\\\.|[^ ])+\\.(?:m|mm|c|cc|cpp|cxx|swift)))\\s.*";

/*
 * Captured groups:
 * - 1: compiler command
 * - 2: file path
 */
NSString * const THXRegularExpressionCompileCommandMatcher = @"\\s*(.*\\/bin\\/clang\\s.*\\s\\-c\\s(.*\\.(?:m|mm|c|cc|cpp|cxx))\\s.*\\.o)$";

/*
 * Captured groups:
 * - 1: file path
 * - 2: file name
 */
NSString * const THXRegularExpressionCompileXIBMatcher = @"CompileXIB\\s(.*\\/(.*\\.xib))";

/*
 * Captured groups:
 * - 1: file path
 * - 2: file name
 */
NSString * const THXRegularExpressionCompileStoryboardMatcher = @"CompileStoryboard\\s(.*\\/([^\\/].*\\.storyboard))";

/*
 * Captured groups:
 * - 1: source file
 * - 2: target file
 */
NSString * const THXRegularExpressionCopyHeaderMatcher = @"CpHeader\\s(.*\\.h)\\s(.*\\.h)";

/*
 * Captured groups:
 * - 1: source file
 * - 2: target file
 */
NSString * const THXRegularExpressionCopyPlistMatcher = @"CopyPlistFile\\s(.*\\.plist)\\s(.*\\.plist)";

/*
 * Captured groups:
 * - 1: file
 */
NSString * const THXRegularExpressionCopyStringsMatcher = @"CopyStringsFile.*\\/(.*.strings)";

/*
 * Captured groups:
 * - 1: resource
 */
NSString * const THXRegularExpressionCpresourceMatcher = @"CpResource\\s(.*)\\s\\/";

/*
 * Captured groups: none
 */
NSString * const THXRegularExpressionExecutedMatcher = @"\\s*Executed";

/*
 * Captured groups:
 * - 1: file
 * - 2: test suite
 * - 3: test case
 * - 4: reason
 */
NSString * const THXRegularExpressionFailingTestMatcher = @"\\s*(.+:\\d+):\\serror:\\s[\\+\\-]\\[(.*)\\s(.*)\\]\\s:(?:\\s'.*'\\s\\[FAILED\\],)?\\s(.*)";

/*
 * Captured groups:
 * - 1: file
 * - 2: reason
 */
NSString * const THXRegularExpressionUiFailingTestMatcher = @"\\s{4}t = \\s+\\d+\\.\\d+s\\s+Assertion Failure: (.*:\\d+): (.*)$";

/*
 * Captured groups:
 * - 1: dsym
 */
NSString * const THXRegularExpressionGenerateDsymMatcher = @"GenerateDSYMFile \\/.*\\/(.*\\.dSYM)";

/*
 * Captured groups:
 * - 1: library
 */
NSString * const THXRegularExpressionLibtoolMatcher = @"Libtool.*\\/(.*\\.a)";

/*
 * Captured groups:
 * - 1: target
 * - 2: build variants
 * - 3: architecture
 */
NSString * const THXRegularExpressionLinkingMatcher = @"Ld \\/?.*\\/(.*?) (.*) (.*)$";

/*
 * Captured groups:
 * - 1: suite
 * - 2: test case
 * - 3: time
 */
NSString * const THXRegularExpressionTestCasePassedMatcher = @"\\s*Test Case\\s'-\\[(.*)\\s(.*)\\]'\\spassed\\s\\((\\d*\\.\\d{3})\\sseconds\\)";

/*
 * Captured groups:
 * - 1: suite
 * - 2: test case
 */
NSString * const THXRegularExpressionTestCaseStartedMatcher = @"Test Case '-\\[(.*) (.*)\\]' started.$";

/*
 * Captured groups:
 * - 1: suite
 * - 2: test case
 */
NSString * const THXRegularExpressionTestCasePendingMatcher = @"Test Case\\s'-\\[(.*)\\s(.*)PENDING\\]'\\spassed";

/*
 * Captured groups:
 * - 1: suite
 * - 2: test case
 * - 3: time
 */
NSString * const THXRegularExpressionTestCaseMeasuredMatcher = @"[^:]*:[^:]*:\\sTest Case\\s'-\\[(.*)\\s(.*)\\]'\\smeasured\\s\\[Time,\\sseconds\\]\\saverage:\\s(\\d*\\.\\d{3}),";

/*
 * Captured groups:
 * - 1: phase
 */
NSString * const THXRegularExpressionPhaseSuccessMatcher = @"\\*\\*\\s(.*)\\sSUCCEEDED\\s\\*\\*";

/*
 * Captured groups:
 * - 1: script name
 */
NSString * const THXRegularExpressionPhaseScriptExecutionMatcher = @"PhaseScriptExecution\\s((\\\\\\ |\\S)*)\\s";

/*
 * Captured groups:
 * - 1: file
 */
NSString * const THXRegularExpressionProcessPCHMatcher = @"ProcessPCH\\s.*\\s(.*.pch)";

/*
 * Captured groups:
 * - 1: file path
 */
NSString * const THXRegularExpressionProcessPCHCommandMatcher = @"\\s*.*\\/usr\\/bin\\/clang\\s.*\\s\\-c\\s(.*)\\s\\-o\\s.*";

/*
 * Captured groups:
 * - 1: file
 */
NSString * const THXRegularExpressionPreprocessMatcher = @"Preprocess\\s(?:(?:\\\\ |[^ ])*)\\s((?:\\\\ |[^ ])*)$";

/*
 * Captured groups:
 * - 1: file
 */
NSString * const THXRegularExpressionPBXCPMatcher = @"PBXCp\\s((?:\\\\ |[^ ])*)";

/*
 * Captured groups:
 * - 1: file
 */
NSString * const THXRegularExpressionProcessInfoPlistMatcher = @"ProcessInfoPlistFile\\s.*\\.plist\\s(.*\\/+(.*\\.plist))";

/*
 * Captured groups:
 * - 1: suite
 * - 2: time
 */
NSString * const THXRegularExpressionTestsRunCompletionMatcher = @"\\s*Test Suite '(?:.*\\/)?(.*[ox]ctest.*)' (finished|passed|failed) at (.*)";

/*
 * Captured groups:
 * - 1: suite
 * - 2: time
 */
NSString * const THXRegularExpressionTestSuiteStartedMatcher = @"\\s*Test Suite '(?:.*\\/)?(.*[ox]ctest.*)' started at(.*)";

/*
 * Captured groups:
 * - 1: test suite name
 */
NSString * const THXRegularExpressionTestSuiteStartMatcher = @"\\s*Test Suite '(.*)' started at";

/*
 * Captured groups:
 * - 1: file name
 */
NSString * const THXRegularExpressionTiffutilMatcher = @"TiffUtil\\s(.*)";

/*
 * Captured groups:
 * - 1: file path
 * - 2: file name
 */
NSString * const THXRegularExpressionTouchMatcher = @"Touch\\s(.*\\/(.+))";

/*
 * Captured groups:
 * - 1: file path
 */
NSString * const THXRegularExpressionWriteFileMatcher = @"write-file\\s(.*)";

/*
 * Captured groups: none
 */
NSString * const THXRegularExpressionWriteAuxiliaryFiles = @"Write auxiliary files";

/*******************************************************************************
 * WARNINGS
 ******************************************************************************/

/*
 * Captured groups:
 * - 1: file path
 * - 2: file name
 * - 3: reason
 */
NSString * const THXRegularExpressionCompileWarningMatcher = @"(\\/.+\\/(.*):.*:.*):\\swarning:\\s(.*)$";

/*
 * Captured groups:
 * - 1: ld prefix
 * - 2: warning message
 */
NSString * const THXRegularExpressionLDWarningMatcher = @"(ld: )warning: (.*)";

/*
 * Captured groups:
 * - 1: whole warning
 */
NSString * const THXRegularExpressionGenericWarningMatcher = @"warning:\\s(.*)$";

/*
 * Captured groups:
 * - 1: whole warning
 */
NSString * const THXRegularExpressionWillNotBeCodeSignedMatcher = @"(.* will not be code signed because .*)$";

/*******************************************************************************
 * ERRORS
 ******************************************************************************/

/*
 * Captured groups:
 * - 1: whole error
 */
NSString * const THXRegularExpressionClangErrorMatcher = @"(clang: error:.*)$";

/*
 * Captured groups:
 * - 1: whole error
 */
NSString * const THXRegularExpressionCheckDependenciesErrorsMatcher = @"(Code\\s?Sign error:.*|Code signing is required for product type .* in SDK .*|No profile matching .* found:.*|Provisioning profile .* doesn't .*|Swift is unavailable on .*|.?Use Legacy Swift Language Version.*)$";

/*
 * Captured groups:
 * - 1: whole error
 */
NSString * const THXRegularExpressionProvisioningProfileRequiredMatcher = @"(.*requires a provisioning profile.*)$";

/*
 * Captured groups:
 * - 1: whole error
 */
NSString * const THXRegularExpressionNoCertificateMatcher = @"(No certificate matching.*)$";

/*
 * Captured groups:
 * - 1: file path
 * - 2: file name
 * - 3: reason
 */
NSString * const THXRegularExpressionCompileErrorMatcher = @"(\\/.+\\/(.*):.*:.*):\\s(?:fatal\\s)?error:\\s(.*)$";

/*
 * Captured groups:
 * - 1: cursor
 */
NSString * const THXRegularExpressionCursorMatcher = @"([\\s~]*\\^[\\s~]*)$";

/*
 * Captured groups:
 * - 1: whole error
*/
NSString * const THXRegularExpressionFatalErrorMatcher = @"(fatal error:.*)$";

/*
 * Captured groups:
 * - 1: whole error.
 * - 2: file path
 */
NSString * const THXRegularExpressionFileMissingErrorMatcher = @"<unknown>:0:\\s(error:\\s.*)\\s'(\\/.+\\/.*\\..*)'$";

/*
 * Captured groups:
 * - 1: whole error
 */
NSString * const THXRegularExpressionLDErrorMatcher = @"(ld:.*)";

/*
 * Captured groups:
 * - 1: file path
 */
NSString * const THXRegularExpressionLinkerDuplicateSymbolsLocationMatcher = @"\\s+(\\/.*\\.o[\\)]?)$";

/*
 * Captured groups:
 * - 1: reason
 */
NSString * const THXRegularExpressionLinkerDuplicateSymbolsMatcher = @"(duplicate symbol .*):$";

/*
 * Captured groups:
 * - 1: symbol location
 */
NSString * const THXRegularExpressionLinkerUndefinedSymbolLocationMatcher = @"(.* in .*\\.o)$";

/*
 * Captured groups:
 * - 1: reason
 */
NSString * const THXRegularExpressionLinkerUndefinedSymbolsMatcher = @"(Undefined symbols for architecture .*):$";

/*
 * Captured groups:
 * - 1: reason
 */
NSString * const THXRegularExpressionPodsErrorMatcher = @"(error:\\s.*)";

/*
 * Captured groups:
 * - 1: reference
 */
NSString * const THXRegularExpressionSymbolReferencedFromMatcher = @"\\s+\"(.*)\", referenced from:$";
