require "./docs"
require "http/client"
require "lexbor"

puts "Starting."

channel = Channel({String, Doc}).new
entries = ["Enumerable", "Hash", "String", "Time"]

puts "TODO: Store entries."

entries.each { |entry|
  puts "TODO: Entry '#{entry}' not found, fetching."

  spawn do
    response = HTTP::Client.get "https://crystal-lang.org/api/1.7.3/#{entry}.html"

    if response.status_code != 200
      channel.send({"", Doc.new})
      next
    end

    instance_methods = response.body.lines
      .skip_while { |line|
        line.includes? "Instance Method Detail"
      }
      .take_while { |line|
        !line.includes? "View source"
      }

    parser = Lexbor::Parser.new(instance_methods.join("\n"))

    summaries = parser.css(".entry-summary").to_a

    methods = summaries.map { |summary|
      summary.inner_text
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

    channel.send({entry, doc})
  end
}

docs = Docs.new

puts "Waiting."

entries.size.times do
  entry, doc = channel.receive
  if entry != ""
    docs.insert(entry, doc)
  end
end

puts "Done."

results, errors = docs.find("string inde")

puts "Searching."

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
