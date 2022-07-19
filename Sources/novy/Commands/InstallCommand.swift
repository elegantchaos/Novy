// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ArgumentParser
import CommandShell
import Files
import Foundation
import Runner

struct InstallCommand: НовыйCommand {
    @Argument(help: "The name of the template repo on github, in the form owner/repo") var template: String
    @OptionGroup() var common: CommandShellOptions

    public static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "install",
            abstract: "Install a template from github.",
            discussion: """
                The template to be installed should live in a repo on github.

                The location of the repo should be specified as `owner/name`.

                If the `name` part is prefixed with `template-something`, that is stripped off
                when installing the template in novy, so the final template will be called `something`.

                (This allows you to name all your templates in a distinct way in github).

                (Note that the requirement to use Github is hard-coded at the moment, but there's
                no reason in principle that any git repo couldn't be used. Please file a pull request!)
                """
        )
    }

    func run() throws {
        let runner = Runner(command: "git", cwd: engine.templates.url)
        let result = try runner.sync(arguments: ["clone", "git@github.com:\(template)"], stdoutMode: .passthrough, stderrMode: .passthrough)
        if result.status != 0 {
            engine.output.log("Failed to clone template.")
            throw ArgumentParser.ExitCode(result.status)
        }

        var name = URL(fileURLWithPath: template).lastPathComponent
        let cloned = engine.templates.folder(ItemName(name))
        if let range = name.range(of: "template-"), range.lowerBound == name.startIndex {
            name.removeSubrange(range)
            try cloned.rename(as: name)
        }

        engine.output.log("Done.\n")
    }
}
