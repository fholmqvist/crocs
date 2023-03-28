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

  def find(namespace_space_method) : {Array(Array(Array(String))), Array(String)}
    namespace, method = namespace_space_method.split(" ")
    namespace = namespace.strip.capitalize
    method = method.strip

    results = [] of Array(Array(String))
    errors = [] of String

    if @lookups.has_key?(namespace)
      doc = @lookups[namespace.capitalize]
      result = doc.find(method)

      if result.size > 0
        results.push(result)
      else
        errors.push("could not find method #{method} in #{namespace}")
      end
    else
      return {[] of Array(Array(String)), ["could not find namespace #{namespace}"]}
    end

    return {results, errors}
  end
end
