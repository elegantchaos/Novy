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

var substitutions = Substitutions.forProject(named: "Example")
substitutions[.string("«user»")] = "Sam Deane"
substitutions[.string("«owner»")] = "Elegant Chaos"
substitutions[.string("«date»")] = shortDate
substitutions[.string("«year»")] = year

duplicator.clone(template: template, into: destination, substitutions: substitutions)
