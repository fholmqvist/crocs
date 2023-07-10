require "./*"

cache_file = "/home/#{get_path}/crocs/cache.json"
version = "1.0"
default_entries = ["Enumerable", "Hash", "String", "Time", "Set", "Enum"]

docs = Docs.new

if !File.exists?(cache_file)
  puts "Could not find cache, downloading."
  fetch_from_official_docs(default_entries, docs, cache_file)
end

contents = File.read(cache_file)
docs = Docs.from_json(contents)

missing = (docs.entries.to_set ^ default_entries.to_set).to_a

if missing.size > 1
  puts "Not all entries were found in cache, downloading."
  fetch_from_official_docs(missing, docs, cache_file)
end

global_parser, namespace, method = parse_command_line_inputs(version, default_entries, cache_file, docs)

if !docs.has_entry?(namespace)
  puts "Could not find entry '#{namespace}' in cache, downloading."
  fetch_from_official_docs([namespace], docs, cache_file)
end

results, errors = docs.find(namespace, method)

if errors.size > 0
  errors.each do |error|
    STDERR.puts "ERROR: #{error}"
  end

  STDERR.puts "\n#{global_parser}"
  exit
end

print_results(results)
