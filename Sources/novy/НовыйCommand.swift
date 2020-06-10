// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ArgumentParser
import CommandShell

protocol НовыйCommand: ParsableCommand {
    var common: CommandShellOptions { get }
    var engine: НовыйEngine { get }
}

extension НовыйCommand {
    var engine: НовыйEngine {
        common.loadEngine()
    }
}
