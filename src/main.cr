require "./main_functions"
require "./docs"
require "http/client"
require "lexbor"

filename = "cache.json"

docs = Docs.new

if File.exists?(filename)
  contents = File.read(filename)
  docs = Docs.from_json(contents)
else
  puts "Could not find cache, downloading."

  channel = Channel({String, Doc}).new
  entries = ["Enumerable", "Hash", "String", "Time"]

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

results, errors = docs.find("string inde")

puts "Searching."

if errors.size > 0
  puts errors
else
  puts "Done.\n\n"
  puts "========\n\n"
  print_results(results)
  puts "========\n\n"
end
