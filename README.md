# CROCS!

In a crystalized world without suggestions or autocomplete, oh, how long it takes to search through the documentation! _If only there was a better way_.

This is a small CLI tool for when you need to lookup a method in the docs, again, and has become somewhat frustrated with the situation.

Crystal is an _amazing_ language! Seriously, it's a complete joy to work with. Yes, the compile times are ... very bad. And the tooling is ... very bad. But the language! Oh the language!

I wrote this tool to decrease the pain of working without modern tooling. It's my hope that this tool becomes redundant as soon as possible.

## Usage
```bash
$ crocs -h
Crocs!
    -v, --version                    Show version
    -h, --help                       Show help
    -n NAME, --namespace NAME        Namespace to search in
    -m NAME, --method NAME           Method to search for

$ crocs -n string -m incl
```
