class CWB::Resource
  def self.all
    query = CWB.sparql.select.where(*graph_pattern)
    sparql_solutions = query.execute
    array = format_sparql_solution(sparql_solutions)
  end

  def self.find(uri, container_array = [])
    uri = RDF::URI(uri)
    query = CWB.sparql.select.where(* graph_pattern(uri).each)
    sparql_solutions = query.execute
    hash = format_sparql_solution(sparql_solutions, uri, true)
  end

  def self.nested_all(scope_uri, vocab_uri=nil, tagged=false, container_array = [])
    vocab_uri = RDF::URI(vocab_uri) if vocab_uri
    scope_uri = RDF::URI(scope_uri)
    query = CWB.sparql.select.graph(scope_uri).where(*graph_pattern(scope_uri,nil,nil,vocab_uri))
    sparql_solutions = query.execute
    array = format_sparql_solution(sparql_solutions, scope_uri, subquery=false, tagged)
  end

  def self.nested_find(uri, scope_uri, tagged=false)
    uri = RDF::URI(uri)
    scope_uri = RDF::URI(scope_uri)
    query = CWB.sparql.select.graph(scope_uri).where(*graph_pattern(nil, uri))
    sparql_solutions = query.execute
    hash = format_sparql_solution(sparql_solutions, scope_uri, subquery=true, tagged)
  end

  def self.sparql_format(params)
    # 4store very picky about post data
    
    array = graph_pattern(*params)
    array.each do |a|
      a.each_with_index do |aa, ind|
        if aa.is_a? String
          a[ind] = "\"#{aa}\""
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
    project_uri = '<' + params[0].to_s + '>'
    uri = URI.parse(CWB.endpoint(:update))
    http = Net::HTTP.new(uri.host, uri.port)
    postdata = %Q[update=INSERT+DATA+{+GRAPH+#{ project_uri }+{+#{ triples }+}+}]
    res = http.post(uri.request_uri, postdata)
  end

  def self.turtle_create(params)
    triples = sparql_format(params)
    triples.split('+.').each do |split|
      split = split + '+.'
      split[0] = '' if split[0] == ' '
      split.gsub!('+', ' ')
      Net::HTTP::post_form URI(CWB.endpoint(:data)), 
        { "data" => "#{split}", "graph" => "#{params[0]}", "mime-type" => "application/x-turtle" }
    end
  end

  def self.single_turtle_create(params)
    triples = sparql_format_single(params)
    triples.split('+.').each do |split|
      split = split + '+.'
      split.gsub!('+', ' ')
      split[0] = '' if split[0] == ' '
      Net::HTTP::post_form URI(CWB.endpoint(:data)), 
        { "data" => "#{split}", "graph" => "#{params[0]}", "mime-type" => "application/x-turtle" }
    end
  end

  def self.ssdelete(params)
    project_uri = '<' + params[0].to_s + '>'
    triples = sparql_format_single(params)
    uri = URI.parse(CWB.endpoint(:update))
    http = Net::HTTP.new(uri.host, uri.port)
    postdata = %Q[update=DELETE+DATA+{+GRAPH+#{ project_uri }+{+#{ triples }+}+}]
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = postdata
    response = http.request(request)
  end

  def self.single_create(params)
    project_uri = '<' + params[0].to_s + '>'
    triples = sparql_format_single(params)
    uri = URI.parse(CWB.endpoint(:update))
    http = Net::HTTP.new(uri.host, uri.port)
    postdata = %Q[update=INSERT+DATA+{+GRAPH+#{ project_uri }+{+#{ triples }+}+}]
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = postdata
    response = http.request(request)
  end

  def self.single_delete(params)
    project_uri = '<' + params[0].to_s + '>'
    uri = URI.parse(CWB.endpoint(:update))
    http = Net::HTTP.new(uri.host, uri.port)
    triples = sparql_format_single(params)
    triples.split('+.').each do |split|
      split = split + '+.'
      split[0] = '' if split[0] == ' '
      split.gsub!('+', ' ')
      postdata = %Q[update=DELETE+DATA+{+GRAPH+#{ project_uri }+{+#{ split }+}+}]
      request = Net::HTTP::Post.new(uri.request_uri)
      request.body = postdata
      response = http.request(request)
    end
  end

  def self.sparql_format_single(params)
    # 4store very picky about post data
    params.shift
    params.each_with_index do |a, i|
      if a.is_a? String
        params[i] = %Q[\"#{a}\"]
      else
        params[i] = '<' + a.to_s + '>'
      end
    end
    params << '.'
    t = params.flatten.join('+')
  end

  def self.delete(id, scope_id=nil)
    uri = URI.parse(CWB.endpoint(:update))
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Delete.new(id)
    response = http.request(request)
  end

  def self.update(params)
    project_uri = params[0].to_s
    endpoint = CWB.endpoint

    delete(project_uri)
    create(params)
  end

  def self.format_sparql_solution(sparql_solutions, uri = nil, subquery=false,tagged=false)
    container_array = []
    attrs = {}
    tag_array = []

    if sparql_solutions == []
      return []
    end

    sparql_solutions.each_with_index do |solution, index|
      # bindings defined https://github.com/ruby-rdf/rdf/blob/c97373f394d663cd369c1d1943e1124ae9b224fa/lib/rdf/query/solutions.rb#L97
      solution.bindings.each do |k,v|
        if k == :tag && !(v == 'nil')
          tag_array << v.to_s
        end
        k == :uri ? k = :id : k
        if v.to_s =~ /__/ && k == :label
          hash = Hash[k, v.to_s.gsub!(/__/, ' ')]
        else
          hash = Hash[k, v.to_s]
        end
        attrs.merge!(hash)
      end
      if self == CWB::File
        attrs[:tag] = tag_array.uniq
      end
      return attrs if (subquery && !tagged) || (subquery && ((index + 1) == sparql_solutions.count) && tagged)
      if !subquery && container_array.empty?
        container_array << attrs
        tag_array = []
      elsif !subquery
        if mergable = container_array.detect { |a| a[:id] == attrs[:id] }
          mergable[:tag] << attrs[:tag].first if Array(attrs[:tag]).first && !mergable[:tag].include?(attrs[:tag].first)
        else
          container_array << attrs
        end
        tag_array = []
      end

      attrs = {}
    end
    # .find needs one hash (attrs) .each needs an array (cont_array)
    if container_array.empty?
      attrs
    else
      container_array.sort_by! { |i| i[:label].downcase if i[:label] }
    end
  end
end
