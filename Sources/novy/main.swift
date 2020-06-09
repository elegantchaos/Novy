// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import Files

let fm = FolderManager.shared
let duplicator = Duplicator()
let templates = fm.current.folder(["Extras", "Templates"])
let example = fm.current.up.folder(["TemplateSources", "ActionStatus"])

//templates.create()
//duplicator.import(project: example, into: templates, as: "CatalystApp")

let destination = fm.current.folder("Output")
let template = templates.folder("CatalystApp")
destination.delete()
destination.create()
duplicator.clone(template: template, into: destination, substitutions: [
    "project": "Example",
    "project-lowercase": "example",
    "project-underscore": "EXAMPLE"
])
