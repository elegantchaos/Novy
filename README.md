[comment]: <> (Header Generated by ActionStatus 1.0.2 - 320)

[![Test results][tests shield]][actions] [![Latest release][release shield]][releases] [![swift 5.2 shield] ![swift 5.3 shield] ![swift dev shield]][swift] ![Platforms: macOS][platforms shield]

[release shield]: https://img.shields.io/github/v/release/elegantchaos/Novy
[platforms shield]: https://img.shields.io/badge/platforms-macOS-lightgrey.svg?style=flat "macOS"
[tests shield]: https://github.com/elegantchaos/Novy/workflows/Tests/badge.svg
[swift 5.2 shield]: https://img.shields.io/badge/swift-5.2-F05138.svg "Swift 5.2"
[swift 5.3 shield]: https://img.shields.io/badge/swift-5.3-F05138.svg "Swift 5.3"
[swift dev shield]: https://img.shields.io/badge/swift-dev-F05138.svg "Swift dev"

[swift]: https://swift.org
[releases]: https://github.com/elegantchaos/Novy/releases
[actions]: https://github.com/elegantchaos/Novy/actions

[comment]: <> (End of ActionStatus Header)

# Новый

(_adj_. new, fresh, novel)

Новый is the spiritual successor to an old product of mine, [Neu](https://elegantchaos.com/neu/).

Neu originally existed to make it easy to create new files in the Finder, using a right-click contextual menu. I've always been a Mac user primarily, but it filled in a tiny gap for me where I thought that Windows worked better. I retired it a while back, when I started working on Sketch, as I didn't have time to maintain it. 

Although a desktop app, as Neu it developed, I added some templating abilities which meant that you could create new files that had some values pre-filled. Before I canned it, I was thinking of making a companion command-line tool.

For a while now though I've been wishing I had something like the Neu command line tool that I never got round to. I want to be able to make new files (or groups of files) easily, from a template. I want certain values to be filled in dynamically. I want an arbitrary script to run as part of the setup process, so that other things can happen (for example, a git repo can be created, or git-submodules can be installed and fetched).

That is what Новый is for. 

### The Name

An aside on the name. It means "new" in Russian. I picked it partly because I like Russian, partly in homage to Neu (which is German for "new"). 

A rough English pronounciation would be "novvy". 

I'm not a Russian speaker <sup>[1](#footnote)</sup>, so the cyrillic keyboard isn't normally configured for me. Thus I've called the executable `novy` (just the one v!). 

Feel free to rename it back to Новый locally if you can type it easily :)

## Installation

One day it may become a full application like Neu, but for now it's a command line tool, and you need to clone it, build it, and copy the built executable yourself.

    git clone git@github.com:elegantchaos/novy.git
    swift build --configuration release
    cp .build/release/novy /usr/local/bin/ # or some other location where you put executables


## Usage

Templates can live in github, but are cached locally.

To install a template, you can do `novy install my/repo`. This will fetch the template from `https://github.com/my/repo.git`.

You can see which templates you've got installed with `novy list`. 

To use a template, you do `novy clone my-template <name>` (where `<name>` is the name you want the template to expand with).

## Templates

The templates currently live in `~/.local/share/novy/templates`. 

I use this path to maintain consistency across platforms. I might switch to using `~/Library` at some point on the Mac. I might also add the ability to store them in `/usr/share/` and/or `/Library` as well.

They are basically just folders. 

When a template is cloned, substitutions can be applied to the file names (see below for more information on substitutions). Substitutions are also applied to any file that successfully loads as utf8 text (regardless of file extensions).

### Post Processing

After cloning, if a file called `.novy` exists in the root of the template, it is executed! Typically the idea here is that it is a shell script, which performs additional setup steps. 

**This is obviously dangerous!** You need to be able to trust any template you download from github. Not only could the script do something malicious, but a mistake in it could cause havoc with your machine. Please be aware that you use Новый at your own risk and _I take absolutely no responsibility for any damage it causes_. 

I might switch this out for a more constrained mechanism later, but for now the flexibility is useful.

If you want to edit a template in place, you can reveal it in the Finder with `novy reveal <template>`.

### Substitutions

Templates can contain substitutions in their content, and their file names. 

These are mostly read from  `~/.local/share/novy/settings.json`.

This file takes the form: 

```json
{
    "strings": {
        "key": "value"
    },
    "expressions": {
        "some.*expression": "value"
    },
    "functions": {
        "key": "javascript expression"
    }
}
```

[Note that the `functions` section is not implemented as of v1.0.3!]

In addition to these values, four are supplied dynamically:

- `user`: the value returned by `NSFullUserName`
- `owner`: also the value returned by `NSFullUserName` 
- `date`: the date, in the form: `dd/mm/yyyy`
- `year`: the year, in the form: `yyyy`

The `owner` key is intended to contain an organization name - eg "Elegant Chaos" - for use in things like header comments. 
Although it defaults to the user's name (so that it always has a value), it can be overriden by an entry in `settings.json`, as can all of the dynamic values.

### Placeholders

Normally, substitution engines use some funky punctuation for their placeholders - such as `%%{blah }%%` or `\(blah)`. 

The logic behind this is that it is an attempt to avoid something that could occur naturally in the template text.

The problem with it as an approach is that it's usually a bit format-sensitive. One placeholder style might work for XML files, but contain characters that don't parse in JSON. Another might have the opposite problem.

With complicated templates (such as Xcode projects), it is useful to be able to open the actual template, modify it, and save it again - so that the template itself can be improved over time. The original dellimiters that I tried broke the parsing of the XML that Xcode uses (for things like the `xcworkspacedata` files), meaning that Xcode wouldn't open the template. 

This was annoying, so I've chosen to use placeholder delimiters which are just ascii text: `xXx`. If your variable is called `foo`, the placeholder will be `xXxfooxXx`.  Whilst this is a little hard to read, it has the advantage of working everywhere that text works. It also generally doesn't break the naming rules for things like variable or function names in programming languages. 

This means that XML or JSON that includes placeholders will still parse, and source code that includes placeholders will generally still compile. 

I think this is worth having.

### Importing

To make it easy to create templates from Xcode projects, I added the `novy import` command, which does a kind of clone in reverse. It performs some backwards substitutions, based on regular expressions, to strip out some things like the author/date/copyright in source files, and replace them with placeholders.

Again, these values are currently hard coded for my needs. I'd be happy to try to generalise this system for everyone, but I may need the motivation of someone asking me to do it :)

### Examples

Some example templates can be found in my github repo:

- [elegantchaos/template-CatalystApp](https://github.com/elegantchaos/template-CatalystApp)
- [elegantchaos/template-SwiftFile](https://github.com/elegantchaos/template-SwiftFile)
- [elegantchaos/template-GitIgnore](https://github.com/elegantchaos/template-GitIgnore)
- [elegantchaos/template-SwiftLibrary](https://github.com/elegantchaos/template-SwiftLibrary)

I'll add more over time.

## Future

Like most of my projects at the moment, this was created for my own use, and partly as a vehicle to drive my own experimentation and learning with Swift.

As such, it's not full-featured, and there may well be mature things out there that do a better job. I'm frankly not that bothered. I will probably continue to develop Новый for my own use, just because. 

That said, I'm interested to hear about other things that are out there. I'd also be delighted to discover that other people want to use Новый. Please submit requests, bug reports, or even pull requests. Or not.

I do plan to make the substitution engine more dynamic.

---

#### Footnote
I spend a couple of years studying Russian at school. If I'm honest, this was mostly because it was an extra option that got me out of sport and religious education... 

I really liked the language, but didn't apply myself properly. I was doing too many other subjects, and my French teacher was way scarier than my Russian one, so I did her homework and skipped the Russian. Weirdly, my Russian teacher was also my Latin teacher. Even more weirdly, my Latin/Russian teacher left halfway through the course, and my (inner-city, state) school managed to replace him with another Russian/Latin teacher. What are the chances?

I would love to learn it properly one day, but that is true of a whole ton of other things (including learning Scottish Gaelic, which is spoken where I live). Anyway I was (and still am) far too much of an introvert to actually speak it to other people. 
