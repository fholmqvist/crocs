require "./doc"
require "json"

class Docs
  include JSON::Serializable

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

  def find(namespace, method) : {Array(Array(Array(String))), Array(String)}
    namespace = namespace.capitalize

    results = [] of Array(Array(String))
    errors = [] of String

    if @lookups.has_key?(namespace)
      doc = @lookups[namespace]
      result = doc.find(method)

      if result.size > 0
        results.push(result)
      else
        errors.push("Could not find method '#{method}' in '#{namespace}'.")
      end
    else
      return {[] of Array(Array(String)), ["Could not find namespace '#{namespace}'."]}
    end

    return {results, errors}
  end

  def entries
    return @lookups.keys
  end

  def serialize
    return @lookups.to_json
  end
end
