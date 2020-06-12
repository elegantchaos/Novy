// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ArgumentParser
import CommandShell
import Foundation
import Runner

struct CloneCommand: НовыйCommand {
    @Argument(help: "The name of the template to clone.") var template: String
    @Argument(help: "The location to use when expanding the template. Defaults to the working directory.") var destination: String?
    @OptionGroup() var common: CommandShellOptions

    static public var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "clone",
            abstract: "Create a new item from a template.",
            discussion: """
                The template is expanded into the supplied destination, which is relative
                to the working directory. If no destination is supplied, the current working
                directory is used.

                Some templates require a name to use in their expansions. If the destination is
                supplied, the last part of it is used as the name. If not, the template name is
                used.
                """
        )
    }
    
    func run() throws {
        let template = engine.template(named: self.template)
        let destination = engine.relativeFolder([self.destination ?? self.template])
        
        let now = Date()
        let shortDate = DateFormatter.localizedString(from: now, dateStyle: .short, timeStyle: .none)
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        let year = formatter.string(from: now)

        let container = destination.up
        try container.create()
        let variables: Variables = [
            .userKey: UserDefaults.standard.string(forKey: "User") ?? NSFullUserName(), // set with: `defaults write novy User "Sam Deane"`
            .ownerKey: UserDefaults.standard.string(forKey: "Owner") ?? NSFullUserName(), // set with: `defaults write novy Owner "Elegant Chaos"`
            .dateKey: shortDate,
            .yearKey: year,
        ]

        let name = destination.name.name
        try engine.clone(template: template, into: destination.up, as: name, variables: variables)
        
        let commands = template.file(".novy")
        if commands.exists {
            let runner = Runner(for: commands.url, cwd: container.url)
            let result = try runner.sync(arguments: [name, template.path, destination.path], stdoutMode: .passthrough, stderrMode: .passthrough)
            if result.status != 0 {
                engine.output.log("The .novy commands file returned a non-zero status.")
                throw ArgumentParser.ExitCode(result.status)
            }
        }
        
        engine.output.log("Done.")
    }
}
