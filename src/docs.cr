class Docs
  @lookups : Hash(String, Doc)

  def initialize
    @lookups = {} of String => Doc
  end

  def initialize(@lookups)
  end

  def insert(entry, doc)
    @lookups[entry] = doc
  end

  def inspect
    @lookups.each { |entry, doc|
      puts "\n======== #{entry} ========\n\n"
      doc.inspect
    }
  end
end

class Doc
  @lookup : Hash(String, Array(Array(String)))

  def initialize
    @lookup = {} of String => Array(Array(String))
  end

  def initialize(@lookup)
  end

  def inspect
    @lookup.each { |k, vs|
      puts k
      vs.each { |v|
        puts "  - #{v}"
      }
    }
  end

  def insert(method_name, method)
    if @lookup.has_key?(method_name)
      @lookup[method_name].push(method)
    else
      @lookup[method_name] = [method]
    end
  end
end
