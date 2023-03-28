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

  methods.each { |method|
    puts method
  }
end
