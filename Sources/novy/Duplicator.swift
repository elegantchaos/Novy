// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import Files

class Duplicator {
    let fileManager = FileManager.default
    
    func clone(template: Folder, into destination: Folder) {
        print("cloning from \(template) into \(destination).")
        
        template.copy(to: destination)
//        template.forEach(inParallelWith: destination, filter: .visible) { item, parallel in
//            if item.isFile {
//                let name = item.name.renamed(as: item.name.name.replacingOccurrences(of: "ActionStatus", with: "«project»"))
//                item.copy(to: parallel!, as: name)
//            }
//        }
        
        template.forEach(order: .foldersFirst, recursive: true) { item in
            if item.name.name.contains("ActionStatus") {
                print("blah")
            }
            let name = item.name.renamed(as: item.name.name.replacingOccurrences(of: "ActionStatus", with: "«project»"))
            if name != item.name {
                item.rename(as: name)
            }
        }
    }
}
