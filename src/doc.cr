require "json"

class Doc
  include JSON::Serializable

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

  def insert(method_name : String, method : Array(String))
    method_name = method_name.downcase

    if @lookup.has_key?(method_name)
      @lookup[method_name].push(method)
    else
      @lookup[method_name] = [method]
    end
  end

  def find(method : String)
    method = method.downcase

    result = [] of Array(String)
    @lookup.each_key { |entry|
      if entry.includes?(method)
        result.push(@lookup[entry].flatten)
      end
    }

    result
  end
end
