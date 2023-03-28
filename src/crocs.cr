require "./docs"
require "http/client"
require "lexbor"

docs = Docs.new

{"Enumerable", "Hash", "String", "Time"}.each do |entry|
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

  doc = Doc.new
  methods.each { |method|
    # Remove everything after first parens or space-colon-space, trim end.
    method_name = method[0][1..method[0].index("(")]
    method_name = method_name[0..method_name.index(" : ")]
    method_name = method_name[0..method_name.size - 2]

    doc.insert(method_name, method)
  }

  docs.insert(entry, doc)
end

results, errors = docs.find("string inde")

if errors.size > 0
  puts errors
end

results.each do |namespace|
  namespace.each do |method|
    method.each do |line|
      puts line
    end
    puts "\n"
  end
end
