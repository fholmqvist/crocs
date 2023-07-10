require "option_parser"

def parse_command_line_inputs(version, default_entries, cache_file, docs)
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
      File.delete(cache_file)
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

  if namespace.size == 0
    puts global_parser
    exit
  end

  {global_parser, namespace.capitalize, method}
end
