# crocs!

What do you get when you have an extremely expressive language without an LSP? Docs! Oh, how long it takes to search through the documentation! _If only there was a better way_.

This is a small CLI tool for when you need to lookup a method in the docs, again, and have become somewhat frustrated with the situation. It's my hope that this tool becomes redundant as soon as possible.

Crystal is an _amazing_ language! Seriously, it's a complete joy to work with.

Yes, the compile times are ... bad[^1].
<br>And the tooling ... isn't[^2].

I strongly believe that the sole thing that's holding Crystal back is the dev experience throwback to the 1990s. To me, this little CLI helps a little bit. Maybe it can help you too.

## Usage

Install:
```
$ make install
crystal build --release src/main.cr
sudo mv main /usr/bin/ crocs
[sudo] password for user:
Installed crocs OK.
```

Help:
```
crocs!
    -v, --version                    Show version
    -h, --help                       Show help
    -n NAME, --namespace NAME        Namespace to search in
    -m NAME, --method NAME           Method to search for
    -l, --list                       List cache entries
    -a, --add                        Add an entry to the cache
    -c, --clear                      Clear the cache

Namespace and method can also be passed as args: './crocs string rind'
Method can be omitted to list all instance methods.
```

Searching:
```
$ crocs string rind

#rindex(search : Char, offset = size - 1)
  Returns the index of the last appearance of search in the string, If offset is present, it defines the position to end the search (characters beyond this point are ignored).

#rindex(search : String, offset = size - search.size) : Int32 | Nil
  Returns the index of the last appearance of search in the string, If offset is present, it defines the position to end the search (characters beyond this point are ignored).

#rindex(search : Regex, offset = size) : Int32 | Nil
  Returns the index of the last appearance of search in the string, If offset is present, it defines the position to end the search (characters beyond this point are ignored).

#rindex!(search : Regex, offset = size) : Int32
  Returns the index of the last appearance of search in the string, If offset is present, it defines the position to end the search (characters beyond this point are ignored).

#rindex!(search : String, offset = size - search.size) : Int32
  Returns the index of the last appearance of search in the string, If offset is present, it defines the position to end the search (characters beyond this point are ignored).

#rindex!(search : Char, offset = size - 1) : Int32
  Returns the index of the last appearance of search in the string, If offset is present, it defines the position to end the search (characters beyond this point are ignored).
```

[^1]: They're getting better though! Quite a bit even. I hope/wish that the interpreter eventually becomes the non-release build mechanism so that it's possible to write Crystal with a very short feedback cycle, yet retain the heavier optimizations for real builds.

[^2]: I am spoiled by Go, but then again I can't recall using a single programming language in the last ~5 years or so that didn't have a mechanism for autocompletion, in-editor-linting etc.
