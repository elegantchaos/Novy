import Foundation


class Duplicator {
    func clone(template: URL, into destination: URL) {
        print("cloning from \(template) into \(destination).")
    }
}

let duplicator = Duplicator()
let template = URL(fileURLWithPath: "/Users/sam/Projects/novy/Extras/Templates/Example")
let destination = URL(fileURLWithPath: "/Users/sam/Desktop")

duplicator.clone(template: template, into: destination)
