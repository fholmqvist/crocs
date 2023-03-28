require "./main_functions"
require "./docs"
require "option_parser"

filename = "cache.json"
version = "1.0"
entries = ["Enumerable", "Hash", "String", "Time", "Set", "Enum"]

docs = Docs.new

if File.exists?(filename)
  contents = File.read(filename)
  docs = Docs.from_json(contents)

  missing = (docs.entries.to_set ^ entries.to_set).to_a

  if missing.size > 1
    puts "Not all entries were found in cache, downloading."
    fetch_from_official_docs(missing, docs, filename)
  end
else
  puts "Could not find cache, downloading."
  fetch_from_official_docs(entries, docs, filename)
end

namespace = ""
method = ""
global_parser = nil

OptionParser.parse do |parser|
  global_parser = parser

  parser.banner = "Crocs!"

  parser.on "-v", "--version", "Show version" do
    puts version
    exit
  end

  parser.on "-h", "--help", "Show help" do
    puts parser
    puts "\nNamespace and method can also be passed as args: './crocs string rind'"
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
    end
  end
end

if namespace.size > 0 && method.size == 0
  STDERR.puts "ERROR: Searching requires both a namespace and a method to be searched for.\n\n"
  STDERR.puts global_parser
  exit(1)
end

if namespace.size == 0 && method.size > 0
  STDERR.puts "ERROR: Searching requires both a namespace and a method to be searched for.\n\n"
  STDERR.puts global_parser
  exit(1)
end

if namespace.size > 0 && method.size > 0
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
