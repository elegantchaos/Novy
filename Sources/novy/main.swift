// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import Files

let fm = FolderManager.shared
let duplicator = Duplicator()
let templates = fm.current.folder(["Extras", "Templates"])
let example = templates.folder("example")
let destination = fm.current.folder("Output")
let actionstatus = fm.current.up.folder("ActionStatus")

duplicator.import(project: actionstatus, into: templates)

//destination.delete()
//destination.create()
//duplicator.clone(template: template, into: destination, substitutions: [
//    "project": "Example"
//])
