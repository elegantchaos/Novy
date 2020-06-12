// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ArgumentParser
import CommandShell
import Foundation
import Runner

struct CloneCommand: НовыйCommand {
    @Argument() var template: String
    @Argument() var destination: String
    @OptionGroup() var common: CommandShellOptions

    static public var configuration: CommandConfiguration {
        CommandConfiguration(commandName: "clone", abstract: "Create a new item from a template.")
    }
    
    func run() throws {
        let template = engine.template(named: self.template)
        let destination = engine.relativeFolder([self.destination])
        
        let now = Date()
        let shortDate = DateFormatter.localizedString(from: now, dateStyle: .short, timeStyle: .none)
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        let year = formatter.string(from: now)

        try? destination.delete()
        try destination.create()

        let variables: Variables = [
            .userKey: UserDefaults.standard.string(forKey: "User") ?? NSFullUserName(), // set with: `defaults write novy User "Sam Deane"`
            .ownerKey: UserDefaults.standard.string(forKey: "Owner") ?? NSFullUserName(), // set with: `defaults write novy Owner "Elegant Chaos"`
            .dateKey: shortDate,
            .yearKey: year,
        ]

        try engine.clone(template: template, into: destination.up, as: destination.name.name, variables: variables)
        
        let commands = template.file(".novy")
        if commands.exists {
            let runner = Runner(for: commands.url, cwd: engine.fm.locations.current.url)
            let result = try runner.sync(arguments: [], stdoutMode: .passthrough, stderrMode: .passthrough)
            if result.status != 0 {
                engine.output.log("The .novy commands file returned a non-zero status.")
                throw ArgumentParser.ExitCode(result.status)
            }
        }
        
        engine.output.log("Done.")
    }
}
