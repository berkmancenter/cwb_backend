class CWB::Resource

  def self.all
    # block being passed gives rails server output showing triples being passed in
    query = CWB.sparql.select.where(* graph_pattern.each { |f| p f } )
    sparql_solutions = query.execute
    array = format_sparql_solution(sparql_solutions)
  end

  def self.find(uri, container_array = [])
    uri = RDF::URI(uri)
    query = CWB.sparql.select.where(* graph_pattern(uri).each) 
    # gives some useful output to rails server log
    p query
    sparql_solutions = query.execute
    hash = format_sparql_solution(sparql_solutions, uri, true)
  end

  def self.nested_each(scope_uri, container_array = [])
    scope_uri = RDF::URI(scope_uri)
    query = CWB.sparql.select.graph(scope_uri).where(*graph_pattern.each)
    # gives some useful output to rails server log
    p query
    sparql_solutions = query.execute
    # pass true to set subquery? boolean
    array = format_sparql_solution(sparql_solutions, scope_uri, false)
  end

  def self.nested_find(uri, scope_uri)
    uri = RDF::URI(uri)
    scope_uri = RDF::URI(scope_uri)
    query = CWB.sparql.select.graph(scope_uri).where(*graph_pattern(uri))
    # gives some useful output to rails server log
    p query
    sparql_solutions = query.execute
    # pass true to set subquery? boolean
    hash = format_sparql_solution(sparql_solutions, scope_uri, true)
  end
  
  def self.create(params)
    CWB.sparql(:update).insert_data(
      RDF::Graph.new do |graph|
        graph_pattern(params[0], params[1], params[2], params[3]).each do |i|
          graph << i
        end
      end,
      graph: params[0]
    )
  end

  def self.delete(endpoint, graph)
    uri = URI.parse(endpoint)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Delete.new(graph)
    response = http.request(request)
  end

  def self.update(params)
    graph = params[0].to_s
    endpoint = CWB.endpoint

    delete(endpoint, graph)
    create(params)
  end

  def self.format_sparql_solution(sparql_solutions, uri = nil, is_subquery = false)
    container_array = []
    attrs = {}

    sparql_solutions.each do |solution|
      # bindings defined https://github.com/ruby-rdf/rdf/blob/c97373f394d663cd369c1d1943e1124ae9b224fa/lib/rdf/query/solutions.rb#L97
      solution.bindings.each do |k,v|
        k == :uri ? k = :id : k
        hash = Hash[k, v.to_s]
        attrs.merge!(hash)
      end
      return attrs if is_subquery
      container_array << attrs
      attrs = {}
    end
    # .find needs one hash (attrs) .each needs an array (cont_array)
    container_array.empty? ? attrs : container_array
  end
  def self.unique_uri
    CWB::BASE_URI.join(UUIDTools::UUID.timestamp_create.to_s)
  end
end
