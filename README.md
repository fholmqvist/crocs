# CROCS!

In a crystalized world without suggestions or autocomplete, oh, how long it takes to search through the documentation! _If only there was a better way_.

This is a small CLI tool for when you need to lookup a method in the docs, again, and have become somewhat frustrated with the overly long feedback loop.

Crystal is an _amazing_ language! Seriously, it's a complete joy to work with. Yes, the compile times are ... very bad. And the tooling is ... very bad. But the language! Oh the language!

I wrote this tool to decrease the pain of working without modern tooling. It's my hope that this tool becomes redundant as soon as possible.

## Usage

Help:
```
Crocs!
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
