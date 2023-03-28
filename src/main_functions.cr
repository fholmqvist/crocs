require "http/client"
require "lexbor"

def fetch_from_official_docs(entries, docs, filename)
  channel = Channel({String, Doc}).new

  puts "Making requests to: #{entries.join(", ")}."

  entries.each { |entry| fetch_entry(entry, channel) }

  puts "Waiting for requests to finish."

  wait_for_fetches(entries, channel, docs)

  puts "Done."

  puts "Saving to disk."

  json = docs.serialize
  File.write(filename, %({"lookups": #{json}}))

  puts "Done."
end

def fetch_entry(entry, channel)
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
end

def wait_for_fetches(entries, channel, docs)
  entries.size.times do
    entry, doc = channel.receive
    if entry != ""
      docs.insert(entry, doc)
    end
  end
end

def print_results(results)
  results.each do |namespace|
    namespace.each do |method_lines|
      first = true
      method_lines.each do |line|
        if first
          puts line
          first = false
        else
          puts "  #{line}"
          first = true
          puts "\n"
        end
      end
    end
  end
end
