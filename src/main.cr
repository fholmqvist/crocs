require "./main_functions"
require "./docs"
require "option_parser"

filename = "cache.json"
version = "1.0"
default_entries = ["Enumerable", "Hash", "String", "Time", "Set", "Enum"]

docs = Docs.new

if File.exists?(filename)
  contents = File.read(filename)
  docs = Docs.from_json(contents)

  missing = (docs.entries.to_set ^ default_entries.to_set).to_a

  if missing.size > 1
    puts "Not all entries were found in cache, downloading."
    fetch_from_official_docs(missing, docs, filename)
  end
else
  puts "Could not find cache, downloading."
  fetch_from_official_docs(default_entries, docs, filename)
end

namespace = ""
method = ""
global_parser = nil

OptionParser.parse do |parser|
  global_parser = parser

  parser.banner = "crocs!"

  parser.on "-v", "--version", "Show version" do
    puts version
    exit
  end

  parser.on "-h", "--help", "Show help" do
    puts parser
    puts "\nNamespace and method can also be passed as args: './crocs string rind'"
    puts "Method can be omitted to list all instance methods."
    exit
  end

  parser.on "-n NAME", "--namespace NAME", "Namespace to search in" do |name|
    namespace = name
  end

  parser.on "-m NAME", "--method NAME", "Method to search for" do |name|
    method = name
  end

  parser.on "-l", "--list", "List cache entries" do
    puts "Entries in cache:"
    docs.entries.each do |entry|
      puts "  - #{entry}"
    end
    exit
  end

  parser.on "-a", "--add", "Add an entry to the cache" do |new_entry|
    default_entries.push(new_entry)
  end

  parser.on "-c", "--clear", "Clear the cache" do
    File.delete(filename)
    exit
  end

  parser.missing_option do |option_flag|
    STDERR.puts "ERROR: #{option_flag} is missing something.\n\n"
    STDERR.puts parser
    exit(1)
  end

  parser.invalid_option do |option_flag|
    STDERR.puts "ERROR: #{option_flag} is not a valid option.\n\n"
    STDERR.puts parser
    exit(1)
  end

  global_parser.unknown_args do |options|
    if options.size == 2
      namespace, method = options
    elsif options.size == 1
      namespace = options[0]
    end
  end
end

if namespace.size > 0
  if !docs.has_entry?(namespace)
    puts "Could not find entry '#{namespace}' in cache, downloading."
    fetch_from_official_docs([namespace], docs, filename)
  end

  results, errors = docs.find(namespace, method)

  if errors.size > 0
    errors.each do |error|
      STDERR.puts "ERROR: #{error}"
    end

    STDERR.puts "\n#{global_parser}"
  else
    print_results(results)
  end
else
  puts global_parser
end
