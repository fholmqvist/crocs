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
  puts ""
else
  puts global_parser
end
