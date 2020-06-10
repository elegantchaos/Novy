// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ArgumentParser
import CommandShell
import Foundation

struct DuplicateCommand: НовыйCommand {
    @Argument() var template: String
    @Argument() var destination: String
    @OptionGroup() var common: CommandShellOptions
    
    static public var configuration: CommandConfiguration {
        CommandConfiguration(commandName: "duplicate", abstract: "Create a new item from a template")
    }
    
    func run() throws {
        let template = engine.template(named: self.template)
        let destination = engine.relativeFolder([self.destination])
        
        let now = Date()
        let shortDate = DateFormatter.localizedString(from: now, dateStyle: .short, timeStyle: .none)
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        let year = formatter.string(from: now)

        destination.delete()
        destination.create()

        let variables: Variables = [
            .userKey: "Sam Deane",
            .ownerKey: "Elegant Chaos",
            .dateKey: shortDate,
            .yearKey: year,
        ]

        engine.clone(template: template, into: destination, as: "Example", variables: variables)
    }
}