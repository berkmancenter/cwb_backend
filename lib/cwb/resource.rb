class CWB::Resource
  def self.all
    query = CWB.sparql.select.where(*graph_pattern)
    sparql_solutions = query.execute
    array = format_sparql_solution(sparql_solutions)
  end

  def self.find(uri, container_array = [])
    uri = RDF::URI(uri)
    query = CWB.sparql.select.where(* graph_pattern(uri).each).distinct
    sparql_solutions = query.execute
    hash = format_sparql_solution(sparql_solutions, uri, true)
  end

  def self.nested_all(scope_uri, vocab_uri=nil, container_array = [])
    vocab_uri = RDF::URI("#{vocab_uri}") if vocab_uri
    scope_uri = RDF::URI(scope_uri)
    query = CWB.sparql.select.graph(scope_uri).where(*graph_pattern(scope_uri,nil,nil,vocab_uri)).distinct
    sparql_solutions = query.execute
    # pass true to set subquery? boolean
    array = format_sparql_solution(sparql_solutions, scope_uri, false)
  end

  def self.nested_find(uri, scope_uri)
    uri = RDF::URI(uri)
    scope_uri = RDF::URI(scope_uri)
    query = CWB.sparql.select.graph(scope_uri).where(*graph_pattern(nil, uri)).distinct
    # gives some useful output to rails server log
    sparql_solutions = query.execute
    # pass true to set subquery? boolean
    hash = format_sparql_solution(sparql_solutions, scope_uri, true)
  end

  def self.sparql_format(params)
    # 4store very picky about post data
    
    array = graph_pattern(*params)
    array.each do |a|
      a.each_with_index do |aa, ind|
        if aa.is_a? String
          a[ind] = "'#{aa}'"
        else
          a[ind] = '<' + aa.to_s + '>'
        end
      end
      a << '.'
    end
    t = array.flatten.join('+')
  end

  def self.create(params)
    triples = sparql_format(params)
    graph = '<' + params[0].to_s + '>'
    uri = URI.parse("http://localhost:8890/update/")
    http = Net::HTTP.new(uri.host, uri.port)
    postdata = %Q[update=INSERT+DATA+{+GRAPH+#{ graph }+{+#{ triples }+}+}]
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = postdata
    response = http.request(request)
  end

  def self.turtle_create(params)
    triples = sparql_format(params)
    triples.split('+.').each do |split|
      split = split + '+.'
      split.gsub!('+', ' ')
      split[0] = '' if split[0] == ' '
      Net::HTTP::post_form URI('http://localhost:8890/data/'), 
        { "data" => "#{split}", "graph" => "#{params[0]}", "mime-type" => "application/x-turtle" }
    end
  end

  def self.single_delete(params)
    graph = '<' + params[0].to_s + '>'
    triples = sparql_format_single(params)
    uri = URI.parse('http://localhost:8890/update/')
    http = Net::HTTP.new(uri.host, uri.port)
    postdata = %Q[update=DELETE+DATA+{+GRAPH+#{ graph }+{+#{ triples }+}+}]
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = postdata
    response = http.request(request)
  end


  def self.delete(id, scope_id=nil)
    uri = URI.parse('http://localhost:8890/update/')
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Delete.new(id)
    response = http.request(request)
  end

  def self.update(params)
    graph = params[0].to_s
    endpoint = CWB.endpoint

    delete(graph)
    create(params)
  end

  def self.format_sparql_solution(sparql_solutions, uri = nil, is_subquery = false)
    container_array = []
    attrs = {}

    if sparql_solutions == []
      return []
    end

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
end
