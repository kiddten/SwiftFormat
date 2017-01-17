//
//  CommandLineTests.swift
//  SwiftFormat
//
//  Created by Nick Lockwood on 10/01/2017.
//  Copyright 2017 Nick Lockwood
//
//  Distributed under the permissive zlib license
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/SwiftFormat
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

import XCTest
@testable import SwiftFormat

class CommandLineTests: XCTestCase {

    // MARK: arg preprocessor

    func testPreprocessArguments() {
        let input = ["", "foo", "bar", "-o", "baz", "-i", "4", "-l", "cr", "-s", "inline"]
        let output = ["0": "", "1": "foo", "2": "bar", "output": "baz", "indent": "4", "linebreaks": "cr", "semicolons": "inline"]
        XCTAssertEqual(try! preprocessArguments(input, [
            "output",
            "indent",
            "linebreaks",
            "semicolons",
        ]), output)
    }

    func testEmptyArgsAreRecognized() {
        let input = ["", "--help", "--version"]
        let output = ["0": "", "help": "", "version": ""]
        XCTAssertEqual(try! preprocessArguments(input, [
            "help",
            "version",
        ]), output)
    }

    // MARK: format options to arguments

    func testCommandLineArgumentsHaveValidNames() {
        let arguments = commandLineArguments(for: FormatOptions())
        for key in arguments.keys {
            XCTAssertTrue(commandLineArguments.contains(key), "\(key) is not a valid argument name")
        }
    }

    func testCommandLineArgumentsAreCorrect() {
        let options = FormatOptions()
        let output = ["indent": "4", "allman": "false", "wraparguments": "disabled", "removelines": "enabled", "wrapelements": "beforefirst", "header": "ignore", "insertlines": "enabled", "binarygrouping": "4", "empty": "void", "ranges": "spaced", "trimwhitespace": "always", "decimalgrouping": "millions", "linebreaks": "lf", "closures": "ignore", "commas": "always", "comments": "indent", "ifdef": "indent", "octalgrouping": "4", "hexliteralcase": "uppercase", "hexgrouping": "4", "semicolons": "inline"]
        XCTAssertEqual(commandLineArguments(for: options), output)
    }

    // MARK: format arguments to options

    func testFormatArgumentsAreAllImplemented() {
        CLI.print = { _, _ in }
        for key in formatArguments {
            guard let value = commandLineArguments(for: FormatOptions())[key] else {
                XCTFail(key)
                continue
            }
            do {
                _ = try formatOptionsFor([key: value])
            } catch {
                XCTFail("\(error)")
            }
        }
    }

    // MARK: help line length

    func testHelpLineLength() {
        CLI.print = { message, _ in
            XCTAssertLessThanOrEqual(message.characters.count, 80, message)
        }
        printHelp()
    }
}