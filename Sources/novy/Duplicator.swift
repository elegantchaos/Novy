// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import Files

class Duplicator {
    let fileManager = FileManager.default
    
    func `import`(project: Folder, into templates: Folder) {
        let originalName = project.name.name
        project.copy(to: templates, replacing: true)
        let destination = templates.folder(name: project.name)
        destination.forEach(order: .foldersFirst) { item in
            let name = item.name.renamed(as: item.name.name.replacingOccurrences(of: originalName, with: "«project»"))
            if name != item.name {
                print("Renamed \(item.name) as \(name).")
                item.rename(as: name)
            }
        }
        
        destination.forEach(filter: .files) { item in
            if let file = item as? File, let text = file.asText {
                let processed = text.replacingOccurrences(of: originalName, with: "«project»")
                if processed != text {
                    print("Substituted \(item.name)")
                    file.write(as: processed)
                }
            }
        }
    }

    func clone(template: Folder, into destination: Folder, substitutions: [String:String]) {
        print("cloning from \(template) into \(destination).")
        
        template.copy(to: destination)
        template.forEach(order: .foldersFirst) { item in
            for (key, value) in substitutions {
                let name = item.name.renamed(as: item.name.name.replacingOccurrences(of: "«\(key)»", with: value))
                if name != item.name {
                    item.rename(as: name)
                }
            }
        }
    }
}
