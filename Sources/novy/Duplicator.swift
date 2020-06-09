// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import Files

class Duplicator {
    let fileManager = FileManager.default
    
    func `import`(project: Folder, into templates: Folder, as name: String) {
        print("Importing from \(project) into \(templates) as \(name).")

        let originalName = project.name.name
        let substitutions = [
            originalName: "«project»",
            originalName.lowercased(): "«project-lowercase»",
            "ACTION_STATUS": "«project-underscore»",
        ]
        

        let copied = project.copy(to: templates, replacing: true)
        copied.expandNames(with: substitutions)
        copied.expandTextFiles(with: substitutions)
        copied.rename(as: ItemName(name), replacing: true)
    }

    func clone(template: Folder, into destination: Folder, substitutions: [String:String]) {
        print("Cloning from \(template) into \(destination).")

        var expandedKeys: [String:String] = [:]
        for (key, value) in substitutions {
            expandedKeys["«\(key)»"] = value
        }
        
        let expanded = template.copy(to: destination)
        expanded.expandNames(with: expandedKeys)
        expanded.expandTextFiles(with: substitutions)
    }
}

extension Folder {
    func expandNames(with substitutions: [String:String]) {
        forEach(order: .foldersFirst, recursive: true) { item in
            if item.name.name == ".git" {
                print("Removed \(item).")
                item.delete()
            } else {
                var expandedName = item.name.name
                for (key, value) in substitutions {
                    expandedName = expandedName.replacingOccurrences(of: key, with: value)
                }
                
                let newName = item.name.renamed(as: expandedName)
                if newName != item.name {
                    print("Renamed \(item.name) as \(newName).")
                    item.rename(as: newName)
                }
            }
        }
    }
    
    func expandTextFiles(with substitutions: [String:String]) {
        forEach(filter: .files, recursive: true) { item in
            if let file = item as? File, let text = file.asText {
                var processed = text
                for (key, value) in substitutions {
                    processed = processed.replacingOccurrences(of: key, with: value)
                }
                if processed != text {
                    print("Substituted \(item.name)")
                    file.write(as: processed)
                }
            }
        }
    }
}
