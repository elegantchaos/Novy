// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import Files

let fm = FolderManager.shared
let duplicator = Duplicator()
let template = fm.folder(for: URL(fileURLWithPath: "/Users/sam/Projects/novy/Extras/Templates/Example"))
let destination = fm.folder(for: "/Users/sam/Projects/novy/Output")

destination.delete()
destination.create()
duplicator.clone(template: template, into: destination)
