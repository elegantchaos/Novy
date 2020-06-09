// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import Files

let fm = FolderManager.shared
let duplicator = Duplicator()
let example = fm.current.up.folder(["TemplateSources", "Sources", "ActionStatus"])
let templates = fm.current.up.folder(["TemplateSources", "Templates"])

templates.create()
duplicator.import(project: example, into: templates, as: "CatalystApp", replacing: "Action Status")

let now = Date()
let shortDate = DateFormatter.localizedString(from: now, dateStyle: .short, timeStyle: .none)
let formatter = DateFormatter()
formatter.dateFormat = "YYYY"
let year = formatter.string(from: now)

let destination = fm.current.folder("Output")
let template = templates.folder("CatalystApp")
destination.delete()
destination.create()

var variables = [
    "user": "Sam Deane",
    "owner": "Elegant Chaos",
    "date": shortDate,
    "year": year,
]

duplicator.clone(template: template, into: destination, as: "Example", variables: variables)
