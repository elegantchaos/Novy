// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ArgumentParser
import CommandShell

struct ImportCommand: НовыйCommand {
    @Argument() var from: String
    @Option() var name: String?
    @Option() var replacing: String?
    @OptionGroup() var common: CommandShellOptions
    
    static public var configuration: CommandConfiguration {
        CommandConfiguration(commandName: "import", abstract: "Import a project as a template.")
    }
    
    func run() throws {
        let from = engine.fm.current.folder([self.from])
        let originalName = from.name.name
        let name = self.name ?? originalName
        let replacing = self.replacing ?? originalName
        engine.import(project: from, into: engine.templates, as: name, replacing: replacing)
        engine.output.log("Done.\n")
    }
}
