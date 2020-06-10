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
