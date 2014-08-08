class CWB::Resource
  def self.all
    query = CWB.sparql.select.where(* graph_pattern.each { |f| p f } )
    sparql_solutions = query.each_solution
    array = format_sparql_solution(sparql_solutions)
  end

  def self.format_sparql_solution(sparql_solutions, uri = nil)
    container_array = []
    attrs = {}

    sparql_solutions.each do |solution|
      # bindings defined https://github.com/ruby-rdf/rdf/blob/c97373f394d663cd369c1d1943e1124ae9b224fa/lib/rdf/query/solutions.rb#L97
      solution.bindings.each do |k,v|
        k == :uri ? k = :id : k
        hash = Hash[k, v.to_s]
        attrs.merge!(hash)
      end
      return attrs unless uri.nil?
      container_array << attrs
      attrs = {}
    end

    # .find needs one hash (attrs) .each needs an array (cont_array)
    container_array ? container_array : attrs
  end

  def self.find(uri, container_array = [])
    uri = RDF::URI(uri)
    query = CWB.sparql.select.where(* graph_pattern(uri).each { |f| p f } )
    sparql_solutions = query.each_solution
    hash = format_sparql_solution(sparql_solutions, uri)
  end
end
