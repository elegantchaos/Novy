// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ArgumentParser
import CommandShell

struct ListCommand: НовыйCommand {
    @OptionGroup() var common: CommandShellOptions
    
    static public var configuration: CommandConfiguration {
        CommandConfiguration(commandName: "list", abstract: "List the available templates.")
    }
    
    func run() throws {
        engine.templates.forEach(filter: .folders, recursive: false) { item in
            engine.output.log(item.name.name)
        }
    }
}
