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

    public static var configuration: CommandConfiguration {
        CommandConfiguration(commandName: "import", abstract: "Import a project as a template.")
    }

    func run() throws {
        let from = engine.fm.locations.current.folder([from])
        let originalName = from.name.name
        let name = name ?? originalName
        let replacing = replacing ?? originalName
        try engine.import(project: from, into: engine.templates, as: name, replacing: replacing)
        engine.output.log("Done.\n")
    }
}
