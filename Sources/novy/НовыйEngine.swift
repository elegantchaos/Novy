// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ArgumentParser
import CommandShell
import Files

class НовыйEngine: CommandEngine {
    let fm = FolderManager.shared
    let duplicator = Duplicator()
    var templates: Folder {
        fm.current.up.folder(["TemplateSources", "Templates"])
    }
    
    override class var subcommands: [ParsableCommand.Type] {
        [
            ImportCommand.self,
            DuplicateCommand.self
        ]
    }
}
