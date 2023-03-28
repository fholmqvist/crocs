require "./main_functions"
require "./docs"
require "http/client"
require "lexbor"

puts "Starting."

channel = Channel({String, Doc}).new
entries = ["Enumerable", "Hash", "String", "Time"]

puts "TODO: Store entries."

entries.each { |entry| fetch_entry(entry, channel) }

docs = Docs.new

puts "Waiting."

wait_for_fetches(entries, channel, docs)

puts "Done."

results, errors = docs.find("string inde")

puts "Searching."

if errors.size > 0
  puts errors
end

print_results(results)
