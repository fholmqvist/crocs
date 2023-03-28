require "./main_functions"
require "./docs"
require "option_parser"

filename = "cache.json"
version = "1.0"

docs = Docs.new

if File.exists?(filename)
  contents = File.read(filename)
  docs = Docs.from_json(contents)
else
  fetch_from_official_docs(docs, filename)
end

namespace = ""
method = ""
root_parser = nil

OptionParser.parse do |parser|
  root_parser = parser

  parser.banner = "Crocs!"

  parser.on "-v", "--version", "Show version" do
    puts version
    exit
  end

  parser.on "-h", "--help", "Show help" do
    puts parser
    exit
  end

  parser.on "-n NAME", "--namespace NAME", "Namespace to search in" do |name|
    namespace = name
  end

  parser.on "-m NAME", "--method NAME", "Method to search for" do |name|
    method = name
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
end

if namespace.size > 0 && method.size == 0
  STDERR.puts "ERROR: Searching requires both a namespace and a method to be searched for.\n\n"
  STDERR.puts root_parser
  exit(1)
end

if namespace.size == 0 && method.size > 0
  STDERR.puts "ERROR: Searching requires both a namespace and a method to be searched for.\n\n"
  STDERR.puts root_parser
  exit(1)
end

if namespace.size > 0 && method.size > 0
  results, errors = docs.find(namespace, method)

  if errors.size > 0
    errors.each do |error|
      STDERR.puts "ERROR: #{error}"
    end

    STDERR.puts "\n#{root_parser}"
  else
    print_results(results)
  end
  puts ""
else
  puts root_parser
end
