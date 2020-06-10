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
    lazy var templates = makeTemplates()
    
    internal func makeTemplates() -> Folder {
        let folder = fm.home.folder([".local", "share", "novy", "templates"])
        folder.create()
        return folder
    }
    
    override class var subcommands: [ParsableCommand.Type] {
        [
            ImportCommand.self,
            DuplicateCommand.self
        ]
    }
    
    func template(named name: String) -> Folder {
        return templates.folder([name])
    }
    
    func relativeFolder(_ components: [String]) -> Folder {
        fm.current.folder(components)
    }
}
