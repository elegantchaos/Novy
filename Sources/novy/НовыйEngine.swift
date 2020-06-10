// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ArgumentParser
import CommandShell
import Files

class НовыйEngine: CommandEngine {
    let fm = FolderManager.shared
    lazy var templates = makeTemplates()
    
    internal func makeTemplates() -> Folder {
        let folder = fm.home.folder([".local", "share", "novy", "templates"])
        folder.create()
        return folder
    }
    
    override class var abstract: String { "Tool for creating new files and/or folders from templates." }
    
    override class var subcommands: [ParsableCommand.Type] {
        [
            DuplicateCommand.self,
            ImportCommand.self,
            ListCommand.self,
            RevealCommand.self,
        ]
    }
    
    func template(named name: String) -> Folder {
        return templates.folder([name])
    }
    
    func relativeFolder(_ components: [String]) -> Folder {
        fm.current.folder(components)
    }
    
    func `import`(project: Folder, into templates: Folder, as name: String, replacing: String) {
        output.log("Importing \(project) as \(name).")

        var substitutions = Substitutions.forProject(named: replacing).switched()
        substitutions[.patternString(#"//  Created by (.*) on (.*)\."#)] = "//  Created by \(String.userKey.subtitutionQuoted) on \(String.dateKey.subtitutionQuoted)."
        substitutions[.patternString(#"//  All code \(c\) \d+ - present day, .*\."#)] = "//  All code (c) \(String.yearKey.subtitutionQuoted) - present day, \(String.ownerKey.subtitutionQuoted)."
        
        let copied = project.copy(to: templates, replacing: true)
        expandNames(in: copied, with: substitutions)
        expandTextFiles(in: copied, with: substitutions)
        copied.rename(as: ItemName(name), replacing: true)
    }

    func clone(template: Folder, into destination: Folder, as name: String, variables: Variables) -> Folder {
        output.log("Cloning from \(template) into \(destination).")

        var substitutions = Substitutions.forProject(named: "Example")
        for (key,value) in variables {
            substitutions[.quotedString(key)] = value
        }

        let expanded = template.copy(to: destination)
        expandNames(in: expanded, with: substitutions)
        expandTextFiles(in: expanded, with: substitutions)
        
        let result = expanded.rename(as: ItemName(name), replacing: true)
        
        return result
    }

    func expandNames(in folder: Folder, with substitutions: Substitutions) {
        folder.forEach(order: .foldersFirst, recursive: true) { item in
            if item.name.name == ".git" {
                verbose.log("Removed \(item).")
                item.delete()
            } else {
                let expandedName = item.name.name.applying(substitutions: substitutions)
                let newName = item.name.renamed(as: expandedName)
                if newName != item.name {
                    verbose.log("Renamed \(item.name) as \(newName).")
                    item.rename(as: newName)
                }
            }
        }
    }
    
    func expandTextFiles(in folder: Folder, with substitutions: Substitutions) {
        folder.forEach(filter: .files, recursive: true) { item in
            if let file = item as? File, let text = file.asText {
                let processed = text.applying(substitutions: substitutions)
                if processed != text {
                    verbose.log("Substituted \(item.name)")
                    file.write(as: processed)
                }
            }
        }
    }

}
