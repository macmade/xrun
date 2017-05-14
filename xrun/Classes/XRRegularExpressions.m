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
 * Most of the following regular expressions have been borrowed from the
 * xcpretty project, by Marin Usalj, and adapted for this project.
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
NSString * const XRRegularExpressionAnalyzeMatcher = @"Analyze(?:Shallow)? (.*\\/(.*\\.(?:m|mm|cc|cpp|c|cxx))) *";

/*
 * Captured groups:
 * - 1: target
 * - 2: project
 * - 3: configuration
 */
NSString * const XRRegularExpressionBuildTargetMatcher = @"=== BUILD TARGET (.*) OF PROJECT (.*) WITH.*CONFIGURATION (.*) ===";

/*
 * Captured groups:
 * - 1: target
 * - 2: project
 * - 3: configuration
 */
NSString * const XRRegularExpressionAggregateTargetMatcher = @"=== BUILD AGGREGATE TARGET (.*) OF PROJECT (.*) WITH.*CONFIGURATION (.*) ===";

/*
 * Captured groups:
 * - 1: target
 * - 2: project
 * - 3: configuration
 */
NSString * const XRRegularExpressionAnalyzeTargetMatcher = @"=== ANALYZE TARGET (.*) OF PROJECT (.*) WITH.*CONFIGURATION (.*) ===";

/*
 * Captured groups: none
 */
NSString * const XRRegularExpressionCheckDependenciesMatcher = @"Check dependencies";

/*
 * Captured groups:
 * - 1: command path
 * - 2: arguments
 */
NSString * const XRRegularExpressionShellCommandMatcher = @" {4}(cd|setenv|(?:[\\w\\/:\\\\ \\-.]+?\\/)?[\\w\\-]+) (.*)$";

/*
 * Captured groups:
 * - 1: file path
 * - 1: file name
 */
NSString * const XRRegularExpressionCleanRemoveMatcher = @"Clean.Remove clean (.*\\/(.+))";

/*
 * Captured groups:
 * - 1: target
 * - 2: project
 * - 3: configuration
 */
NSString * const XRRegularExpressionCleanTargetMatcher = @"=== CLEAN TARGET (.*) OF PROJECT (.*) WITH CONFIGURATION (.*) ===";

/*
 * Captured groups:
 * - 1: file path
 * - 2: file name
 */
NSString * const XRRegularExpressionCodesignMatcher = @"CodeSign (.*\\/(.+))";

/*
 * Captured groups:
 * - 1: file path
 * - 1: file name
 */
NSString * const XRRegularExpressionCodesignFrameworkMatcher = @"CodeSign (.*\\/(.+\\.framework))\\/Versions";

/*
 * Captured groups:
 * - 1: file path
 * - 2: file name
 */
NSString * const XRRegularExpressionCompileMatcher = @"Compile[\\w]+ .+? ((?:\\\\.|[^ ])+\\/((?:\\\\.|[^ ])+\\.(?:m|mm|c|cc|cpp|cxx|swift))) .*";

/*
 * Captured groups:
 * - 1: compiler command
 * - 2: file path
 */
NSString * const XRRegularExpressionCompileCommandMatcher = @" *(.*\\/bin\\/clang .* \\-c (.*\\.(?:m|mm|c|cc|cpp|cxx)) .*\\.o)$";

/*
 * Captured groups:
 * - 1: file path
 * - 2: file name
 */
NSString * const XRRegularExpressionCompileXIBMatcher = @"CompileXIB (.*\\/(.*\\.xib))";

/*
 * Captured groups:
 * - 1: file path
 * - 2: file name
 */
NSString * const XRRegularExpressionCompileStoryboardMatcher = @"CompileStoryboard (.*\\/([^\\/].*\\.storyboard))";

/*
 * Captured groups:
 * - 1: source file
 * - 2: target file
 */
NSString * const XRRegularExpressionCopyHeaderMatcher = @"CpHeader (.*\\.h) (.*\\.h)";

/*
 * Captured groups:
 * - 1: source file
 * - 2: target file
 */
NSString * const XRRegularExpressionCopyPlistMatcher = @"CopyPlistFile (.*\\.plist) (.*\\.plist)";

/*
 * Captured groups:
 * - 1: file
 */
NSString * const XRRegularExpressionCopyStringsMatcher = @"CopyStringsFile.*\\/(.*.strings)";

/*
 * Captured groups:
 * - 1: resource
 */
NSString * const XRRegularExpressionCpresourceMatcher = @"CpResource (.*) \\/";

/*
 * Captured groups: none
 */
NSString * const XRRegularExpressionExecutedMatcher = @" *Executed";

/*
 * Captured groups:
 * - 1: file
 * - 2: test suite
 * - 3: test case
 * - 4: reason
 */
NSString * const XRRegularExpressionFailingTestMatcher = @" *(.+:\\d+): error: [\\+\\-]\\[(.*) (.*)\\] :(?: '.*' \\[FAILED\\],)? (.*)";

/*
 * Captured groups:
 * - 1: file
 * - 2: reason
 */
NSString * const XRRegularExpressionUiFailingTestMatcher = @" {4}t =  +\\d+\\.\\d+s +Assertion Failure: (.*:\\d+): (.*)$";

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
NSString * const XRRegularExpressionLinkingMatcher = @"Ld \\/?.*\\/(.*?) (.*) (.*)";

/*
 * Captured groups:
 * - 1: suite
 * - 2: test case
 * - 3: time
 */
NSString * const XRRegularExpressionTestCasePassedMatcher = @" *Test Case '-\\[(.*) (.*)\\]' passed \\((\\d*\\.\\d{3}) seconds\\)";

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
NSString * const XRRegularExpressionTestCasePendingMatcher = @"Test Case '-\\[(.*) (.*)PENDING\\]' passed";

/*
 * Captured groups:
 * - 1: suite
 * - 2: test case
 * - 3: time
 */
NSString * const XRRegularExpressionTestCaseMeasuredMatcher = @"[^:]*:[^:]*: Test Case '-\\[(.*) (.*)\\]' measured \\[Time, seconds\\] average: (\\d*\\.\\d{3}),";

/*
 * Captured groups:
 * - 1: phase
 */
NSString * const XRRegularExpressionPhaseSuccessMatcher = @"\\*\\* (.*) SUCCEEDED \\*\\*";

/*
 * Captured groups:
 * - 1: script name
 */
NSString * const XRRegularExpressionPhaseScriptExecutionMatcher = @"PhaseScriptExecution ((\\\\\\ | )*) ";

/*
 * Captured groups:
 * - 1: file
 */
NSString * const XRRegularExpressionProcessPCHMatcher = @"ProcessPCH .* (.*.pch)";

/*
 * Captured groups:
 * - 1: file path
 */
NSString * const XRRegularExpressionProcessPCHCommandMatcher = @" *.*\\/usr\\/bin\\/clang .* \\-c (.*) \\-o .*";

/*
 * Captured groups:
 * - 1: file
 */
NSString * const XRRegularExpressionPreprocessMatcher = @"Preprocess (?:(?:\\\\ |[^ ])*) ((?:\\\\ |[^ ])*)$";

/*
 * Captured groups:
 * - 1: file
 */
NSString * const XRRegularExpressionPBXCPMatcher = @"PBXCp ((?:\\\\ |[^ ])*)";

/*
 * Captured groups:
 * - 1: file
 */
NSString * const XRRegularExpressionProcessInfoPlistMatcher = @"ProcessInfoPlistFile .*\\.plist (.*\\/+(.*\\.plist))";

/*
 * Captured groups:
 * - 1: suite
 * - 2: time
 */
NSString * const XRRegularExpressionTestsRunCompletionMatcher = @" *Test Suite '(?:.*\\/)?(.*[ox]ctest.*)' (finished|passed|failed) at (.*)";

/*
 * Captured groups:
 * - 1: suite
 * - 2: time
 */
NSString * const XRRegularExpressionTestSuiteStartedMatcher = @" *Test Suite '(?:.*\\/)?(.*[ox]ctest.*)' started at(.*)";

/*
 * Captured groups:
 * - 1: test suite name
 */
NSString * const XRRegularExpressionTestSuiteStartMatcher = @" *Test Suite '(.*)' started at";

/*
 * Captured groups:
 * - 1: file name
 */
NSString * const XRRegularExpressionTiffutilMatcher = @"TiffUtil (.*)";

/*
 * Captured groups:
 * - 1: file path
 * - 2: file name
 */
NSString * const XRRegularExpressionTouchMatcher = @"Touch (.*\\/(.+))";

/*
 * Captured groups:
 * - 1: file path
 * - 2: file name
 */
NSString * const XRRegularExpressionWriteFileMatcher = @"write-file (.*\\/(.+))";

/*
 * Captured groups: none
 */
NSString * const XRRegularExpressionWriteAuxiliaryFiles = @"Write auxiliary files";

/*******************************************************************************
 * ANALYZER WARNINGS
 ******************************************************************************/
 
/*
 * Captured groups:
 * - 1: file path
 * - 2: file name
 * - 3: line number
 * - 4: column number
 * - 5: diagnostic
 */
NSString * const XRRegularExpressionAnalyzerWarningMatcher = @"^(.*\\/(.+)):([0-9]+):([0-9]+): warning: ([^\\n]+)";

/*******************************************************************************
 * WARNINGS
 ******************************************************************************/

/*
 * Captured groups:
 * - 1: file path
 * - 2: file name
 * - 3: reason
 */
NSString * const XRRegularExpressionCompileWarningMatcher = @"(\\/.+\\/(.*):.*:.*): warning: (.*)$";

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
NSString * const XRRegularExpressionGenericWarningMatcher = @"warning: (.*)$";

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
 * - 1: phase
 */
NSString * const XRRegularExpressionPhaseFailedMatcher = @"\\*\\* (.*) FAILED \\*\\*";

/*
 * Captured groups:
 * - 1: whole error
 */
NSString * const XRRegularExpressionClangErrorMatcher = @"(clang: error:.*)$";

/*
 * Captured groups:
 * - 1: whole error
 */
NSString * const XRRegularExpressionCheckDependenciesErrorsMatcher = @"(Code ?Sign error:.*|Code signing is required for product type .* in SDK .*|No profile matching .* found:.*|Provisioning profile .* doesn't .*|Swift is unavailable on .*|.?Use Legacy Swift Language Version.*)$";

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
NSString * const XRRegularExpressionCompileErrorMatcher = @"(\\/.+\\/(.*):.*:.*): (?:fatal )?error: (.*)";

/*
 * Captured groups:
 * - 1: cursor
 */
NSString * const XRRegularExpressionCursorMatcher = @"([ ~]*\\^[ ~]*)$";

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
NSString * const XRRegularExpressionFileMissingErrorMatcher = @"<unknown>:0: (error: .*) '(\\/.+\\/.*\\..*)'$";

/*
 * Captured groups:
 * - 1: whole error
 */
NSString * const XRRegularExpressionLDErrorMatcher = @"(ld:.*)";

/*
 * Captured groups:
 * - 1: file path
 */
NSString * const XRRegularExpressionLinkerDuplicateSymbolsLocationMatcher = @" +(\\/.*\\.o[\\)]?)$";

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
NSString * const XRRegularExpressionPodsErrorMatcher = @"(error: .*)";

/*
 * Captured groups:
 * - 1: reference
 */
NSString * const XRRegularExpressionSymbolReferencedFromMatcher = @" +\"(.*)\", referenced from:$";
