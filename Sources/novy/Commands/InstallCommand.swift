// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ArgumentParser
import CommandShell
import Files
import Foundation
import Runner

struct InstallCommand: НовыйCommand {
    @Argument() var template: String
    @OptionGroup() var common: CommandShellOptions
    
    static public var configuration: CommandConfiguration {
        CommandConfiguration(commandName: "install", abstract: "Install a template.")
    }
    
    func run() throws {
        let runner = Runner(command: "git", cwd: engine.templates.url)
        let result = try runner.sync(arguments: ["clone", "git@github.com:\(template)"], stdoutMode: .passthrough, stderrMode: .passthrough)
        if result.status != 0 {
            engine.output.log("Failed to clone template.")
            throw ArgumentParser.ExitCode(result.status)
        }

        var name = URL(fileURLWithPath: template).lastPathComponent
        let cloned = engine.templates.folder(ItemName(name))
        if let range = name.range(of: "template-"), range.lowerBound == name.startIndex {
            name.removeSubrange(range)
            try cloned.rename(as: name)
        }
        
        engine.output.log("Done.\n")
    }
}
