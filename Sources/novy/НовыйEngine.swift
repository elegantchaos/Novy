// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ArgumentParser
import CommandShell
import Files
import Foundation

class НовыйEngine: CommandEngine {
    let fm = FileManager.default
    lazy var templates = makeTemplates()

    internal func makeTemplates() -> Folder {
        let folder = fm.locations.home.folder([".local", "share", "novy", "templates"])
        do {
            try folder.create()
        } catch {
            fatalError("Couldn't locate or create templates folder.")
        }

        return folder
    }

    override class var abstract: String { "Tool for creating new files and/or folders from templates." }

    override class var subcommands: [ParsableCommand.Type] {
        [
            CloneCommand.self,
            ImportCommand.self,
            InstallCommand.self,
            ListCommand.self,
            RevealCommand.self,
        ]
    }

    func template(named name: String) -> Folder {
        templates.folder([name])
    }

    var substitutions: Substitutions {
        // read extra substitutions from a .novy file if it exists
        // TODO: expand this to read reg ex patterns and functions too
        let settings = templates.up.file("settings.json")
        if !settings.exists {
            settings.write(as: """
                {
                    "strings" : {
                    },
                    "patterns" : {
                    },
                    "functions" : {
                    }
                }
                """)
        }

        guard let data = try? Data(contentsOf: settings.url),
              let json = try? JSONSerialization.jsonObject(with: data, options: []),
              let dictionary = json as? [String: Any] else { return [:] }

        var results = Substitutions()

        if let strings = dictionary["strings"] as? [String: String] {
            for (k, v) in strings {
                results[.quotedString(k)] = v
            }
        }

        if let patterns = dictionary["patterns"] as? [String: String] {
            for (k, v) in patterns {
                if let expression = try? NSRegularExpression(pattern: k, options: []) {
                    results[.pattern(expression)] = v
                }
            }
        }

        // TODO: functions

        return results
    }

    func relativeFolder(_ components: [String]) -> Folder {
        fm.locations.current.folder(components)
    }

    func `import`(project: Folder, into templates: Folder, as name: String, replacing: String) throws {
        output.log("Importing \(project.name) as \(name).")

        var substitutions = Substitutions.forProject(named: replacing).switched()
        // TODO: add the standard Apple templates here.
        substitutions[.patternString(#"//  Created by (.*) on (.*)\."#)] = "//  Created by \(String.userKey.subtitutionQuoted) on \(String.dateKey.subtitutionQuoted)."
        substitutions[.patternString(#"//  All code \(c\) \d+ - present day, .*\."#)] = "//  All code (c) \(String.yearKey.subtitutionQuoted) - present day, \(String.ownerKey.subtitutionQuoted)."
        substitutions[.patternString(#"#  Created by (.*) on (.*)\."#)] = "#  Created by \(String.userKey.subtitutionQuoted) on \(String.dateKey.subtitutionQuoted)."
        substitutions[.patternString(#"#  All code \(c\) \d+ - present day, .*\."#)] = "#  All code (c) \(String.yearKey.subtitutionQuoted) - present day, \(String.ownerKey.subtitutionQuoted)."

        let destination = templates.folder(name)
        try destination.create()
        let copied = try project.copy(to: destination, replacing: true)
        try expandTextFiles(in: copied, with: substitutions)
        try expandNames(in: copied, with: substitutions)
    }

    func clone(template: Folder, into destination: Folder, as name: String, variables: Substitutions) throws {
        output.log("Cloning from \(template) into \(destination).")

        var substitutions = Substitutions.forProject(named: name)
        for (key, value) in variables {
            substitutions[key] = value
        }
        substitutions[.quotedString("name")] = name

        let skipList = [".novy", ".git", ".DS_Store"]
        var expanded: [ThrowingCommon] = []
        try template.forEach(recursive: false) { item in
            if !skipList.contains(item.name.fullName) {
                let copied = try item.copy(to: destination, replacing: true)
                expanded.append(copied)
            }
        }

        for item in expanded {
            try expandTextFiles(in: item, with: substitutions)
            try expandNames(in: item, with: substitutions)
        }
    }

    func expandNames(in item: ThrowingCommon, with substitutions: Substitutions) throws {
        if let folder = item as? Folder {
            try folder.forEach(order: .foldersFirst, recursive: false) { item in
                try expandNames(in: item, with: substitutions)
            }
        }

        let expandedName = item.name.name.applying(substitutions: substitutions)
        let newName = item.name.renamed(as: expandedName)
        if newName != item.name {
            verbose.log("Renamed \(item.name) as \(newName).")
            try item.rename(as: newName, replacing: false)
        }
    }

    func expandTextFiles(in item: ThrowingCommon, with substitutions: Substitutions) throws {
        if let file = item as? File, let text = file.asText {
            let processed = text.applying(substitutions: substitutions)
            if processed != text {
                verbose.log("Substituted \(item.name)")
                file.write(as: processed)
            }
        } else if let folder = item as? Folder {
            try folder.forEach(recursive: false) { item in
                try expandTextFiles(in: item, with: substitutions)
            }
        }
    }
}
