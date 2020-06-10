// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ArgumentParser
import CommandShell

struct ImportCommand: НовыйCommand {
    @OptionGroup() var common: CommandShellOptions
    
    static public var configuration: CommandConfiguration {
        CommandConfiguration(commandName: "import", abstract: "Import a project as a template")
    }
    
    func run() throws {
        let example = engine.fm.current.up.folder(["TemplateSources", "Sources", "ActionStatus"])
        engine.templates.create()
        engine.duplicator.import(project: example, into: engine.templates, as: "CatalystApp", replacing: "Action Status")
    }
}
