// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ArgumentParser
import CommandShell
import FilesKit

struct RevealCommand: НовыйCommand {
    @Argument() var template: String
    @Flag(help: "Print the location of the template to the console, rather than revealing it.") var path: Bool
    @OptionGroup() var common: CommandShellOptions
    
    static public var configuration: CommandConfiguration {
        CommandConfiguration(commandName: "reveal", abstract: "Reveal a template in the Finder.")
    }
    
    func run() throws {
        let template = engine.template(named: self.template)
        if path {
            engine.output.log(template.path)
        } else {
            template.reveal()
        }
    }
}
