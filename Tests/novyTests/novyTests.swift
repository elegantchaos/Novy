import XCTest
import class Foundation.Bundle

final class novyTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.

        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return
        }

        let fooBinary = productsDirectory.appendingPathComponent("novy")

        let process = Process()
        process.executableURL = fooBinary

        let pipe = Pipe()
        process.standardOutput = pipe

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        XCTAssertEqual(output, "OVERVIEW: Tool for creating new files and/or folders from templates.\n\nUSAGE: novy [--version] [--verbose] <subcommand>\n\nOPTIONS:\n  --version               Show the version. \n  --verbose               Enable additional logging. \n  -h, --help              Show help information.\n\nSUBCOMMANDS:\n  clone                   Create a new item from a template.\n  import                  Import a project as a template.\n  install                 Install a template from github.\n  list                    List the available templates.\n  reveal                  Reveal a template in the Finder.\n\n  See \'novy help <subcommand>\' for detailed help.\n")
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
