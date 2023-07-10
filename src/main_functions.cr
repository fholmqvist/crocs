require "http/client"
require "lexbor"

def fetch_from_official_docs(entries, docs, file_path)
  channel = Channel({String, Doc, String | Nil}).new

  puts "Making requests to: #{entries.join(", ")}."

  entries.each { |entry| fetch_entry(entry, channel) }

  puts "Waiting for requests to finish."

  wait_for_fetches(entries, channel, docs)

  puts "Done."

  puts "Saving to disk."

  json = docs.serialize

  create_file_and_folder(file_path)
  File.write(file_path, %({"lookups": #{json}}), File::Permissions::OwnerAll)

  puts "Done."
end

def fetch_entry(entry, channel)
  spawn do
    url = "https://crystal-lang.org/api/1.7.3/#{entry.capitalize}.html"

    response =
      HTTP::Client.get url

    if response.status_code != 200
      channel.send({"", Doc.new,
                    "ERROR: Could not fetch: #{url}"})
      next
    end

    instance_methods = response.body.lines
      .skip_while { |line| line.includes? "Instance Method Detail" }

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

    channel.send({entry, doc, nil})
  end
end

def wait_for_fetches(entries, channel, docs)
  entries.size.times do
    entry, doc, error = channel.receive
    if error
      STDERR.puts error
      exit(1)
    end
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

def get_path
  result_out, result_in = IO.pipe

  res = Process.run("bash", ["-c", "echo $USER"], output: result_in)
  result_in.close

  unless res.success?
    STDERR.puts "error: failed to echo user"
    exit 3
  end

  result_out.try(&.gets_to_end).chomp
end

def create_file_and_folder(file_path)
  folder_path = File.dirname(file_path)

  unless Dir.exists?(folder_path)
    Dir.mkdir_p(folder_path)
  end

  unless File.exists?(file_path)
    File.new(file_path, "w")
  end
end
