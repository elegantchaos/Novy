// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Expressions
import Files
import Foundation

extension String {
    static let projectKey = "project"
    static let projectCamelKey = "projectCamel"
    static let projectLowercaseKey = "projectLowercase"
    static let projectUnderscoreKey = "projectUnderscore"
    static let userKey = "user"
    static let dateKey = "date"
    static let yearKey = "year"
    static let ownerKey = "owner"
    
    var subtitutionQuoted: String { "xXx\(self)xXx" }
}

enum SubstitutionKey: Hashable {
    case string(String)
    case pattern(NSRegularExpression)
}

extension SubstitutionKey {
    static func quotedString(_ string: String) -> Self {
        .string(string.subtitutionQuoted)
    }
    
    static func patternString(_ string: String) -> Self {
        .pattern(try! NSRegularExpression(pattern: string, options: []))
    }
}

typealias Substitutions = [SubstitutionKey:String]
typealias Variables = [String:String]

extension Substitutions {
    static func forProject(named name: String) -> Substitutions {
        let components = name.split(separator: " ")
        let camel = components.joined(separator: "")
        let lower = camel.lowercased()
        let underscore = components.map({ $0.uppercased() }).joined(separator: "_")
        return [
            .quotedString(.projectKey): name,
            .quotedString(.projectCamelKey): camel,
            .quotedString(.projectLowercaseKey): lower,
            .quotedString(.projectUnderscoreKey): underscore
        ]
    }
    
    func switched() -> Self {
        var result: Self = [:]
        for (key, value) in self {
            switch key {
                case .string(let string):
                    result[.string(value)] = string
                default:
                    fatalError("Can't switch non-string substitutions")
            }
        }
        return result
    }
}

class Duplicator {
    let fileManager = FileManager.default
    
    func `import`(project: Folder, into templates: Folder, as name: String, replacing: String) {
        print("Importing from \(project) into \(templates) as \(name).")

        var substitutions = Substitutions.forProject(named: replacing).switched()
        substitutions[.patternString(#"//  Created by (.*) on (.*)\."#)] = "//  Created by \(String.userKey.subtitutionQuoted) on \(String.dateKey.subtitutionQuoted)."
        substitutions[.patternString(#"//  All code \(c\) \d+ - present day, .*\."#)] = "//  All code (c) \(String.yearKey.subtitutionQuoted) - present day, \(String.ownerKey.subtitutionQuoted)."
        
        let copied = project.copy(to: templates, replacing: true)
        copied.expandNames(with: substitutions)
        copied.expandTextFiles(with: substitutions)
        copied.rename(as: ItemName(name), replacing: true)
    }

    func clone(template: Folder, into destination: Folder, as name: String, variables: Variables) {
        print("Cloning from \(template) into \(destination).")

        var substitutions = Substitutions.forProject(named: "Example")
        for (key,value) in variables {
            substitutions[.quotedString(key)] = value
        }

        let expanded = template.copy(to: destination)
        expanded.expandNames(with: substitutions)
        expanded.expandTextFiles(with: substitutions)
        expanded.rename(as: ItemName(name), replacing: true)
    }
}

extension String {
    func applying(substitutions: Substitutions) -> String {
        var processed = self
        for (key, value) in substitutions {
            switch key {
            case .string(let string):
                processed = processed.replacingOccurrences(of: string, with: value)
                
            case .pattern(let pattern):
                processed = pattern.substitute(in: processed) { _, _ in value }
            }
        }
        return processed
    }
}

extension Folder {
    func expandNames(with substitutions: Substitutions) {
        forEach(order: .foldersFirst, recursive: true) { item in
            if item.name.name == ".git" {
                print("Removed \(item).")
                item.delete()
            } else {
                let expandedName = item.name.name.applying(substitutions: substitutions)
                let newName = item.name.renamed(as: expandedName)
                if newName != item.name {
                    print("Renamed \(item.name) as \(newName).")
                    item.rename(as: newName)
                }
            }
        }
    }
    
    func expandTextFiles(with substitutions: Substitutions) {
        forEach(filter: .files, recursive: true) { item in
            if let file = item as? File, let text = file.asText {
                let processed = text.applying(substitutions: substitutions)
                if processed != text {
                    print("Substituted \(item.name)")
                    file.write(as: processed)
                }
            }
        }
    }
}
