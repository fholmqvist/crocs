require "http/client"
require "lexbor"

# "Hash", "String", "Time"

{"Enumerable"}.each do |entry|
  response = HTTP::Client.get "https://crystal-lang.org/api/1.7.3/#{entry}.html"
  instance_methods = response.body.lines
    .skip_while { |line|
      line.includes? "Instance Method Detail"
    }
    .take_while { |line|
      !line.includes? "View source"
    }

  parser = Lexbor::Parser.new(instance_methods.join("\n"))

  entries = parser.css(".entry-summary").to_a

  methods = entries.map { |entry|
    entry.inner_text
      .split("\n")
      .map { |line| line.strip }
      .reject { |line| line == "" }
  }

  lookup = {} of String => Array(Array(String))
  methods.each { |method|
    # Remove everything after first parens of space-colon-space, trim end.
    method_name = method[0][1..method[0].index("(")]
    method_name = method_name[0..method_name.index(" : ")]
    method_name = method_name[0..method_name.size - 2]

    if lookup.has_key?(method_name)
      lookup[method_name].push(method)
    else
      lookup[method_name] = [method]
    end
  }

  lookup.each { |k, vs|
    puts k
    vs.each { |v|
      puts "  - #{v}"
    }
  }
end
