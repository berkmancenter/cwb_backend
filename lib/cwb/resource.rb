class CWB::Resource
  class << self
    attr_accessor :client_class
  end

  def self.client(mode)
    (@client_class || CWB).sparql(mode)
  end

  ##
  # @param  [RDF::Value] resource
  # @return [Array(Array)]
  def self.graph_pattern(resource = nil)
    bind_pattern(const_get(:PATTERN), resource)
  end

  ##
  # @param  [RDF::Value] resource
  # @return [Array(Array)]
  def self.optional_pattern(resource = nil)
    bind_pattern((const_get(:OPTIONAL) rescue []), resource)
  end

  ##
  # @private
  # @param  [Array(Array)] pattern
  # @param  [RDF::Value] resource
  # @return [Array(Array)]
  def self.bind_pattern(pattern, resource)
    if !resource
      pattern
    else
      pattern.map do |triple_pattern|
        triple_pattern.map do |term|
          term.eql?(:resource) ? resource : term
        end
      end
    end
  end

  ##
  # @yield [resource]
  # @yieldparam  [CWB::Resource] resource
  # @yieldreturn [void] ignored
  def self.each(scope_id = nil, &block)
    return enum_for(:each, scope_id) unless block_given?
    graph = scope_id ? RDF::URI(scope_id) : nil
    self.query(graph).execute.each do |result|
      block.call(self.from_bindings(result))
    end
  end

  ##
  # @param  [RDF::URI] id
  # @return [CWB::Resource] or `nil`
  def self.find(id, scope_id = nil)
    id = RDF::URI(id)
    query = CWB.sparql.select
    query = query.from(RDF::URI(scope_id)) if scope_id
    query = query.where(*self.graph_pattern(id)).optional(*self.optional_pattern(id))
    if (results = query.execute).empty?
      nil # not found
    else
      self.new(id, results.first)
    end
  end

  ##
  # @param  [RDF::URI] graph
  # @param  [Hash] options
  # @return [SPARQL::Client::Query]
  def self.query(graph = nil, options = {})
    query = CWB.sparql.select
    query = query.distinct if options[:distinct]
    query = query.graph(graph || :graph)
    query = query.where(*self.graph_pattern)
    query = query.optional(*self.optional_pattern)
    query
  end

  ##
  # @private
  # @param  [RDF::Query::Solution] bindings
  # @return [CWB::Resource]
  def self.from_bindings(bindings)
    attrs = {}
    bindings.each_binding do |name, value|
      attrs[name] = value unless name.eql?(:resource)
    end
    self.new(bindings.resource, attrs)
  end

  def initialize(id, attrs = {})
    @id = id
    attrs.each do |k, v|
      instance_variable_set("@#{k}", v)
    end
  end

  def [](attr_name)
    instance_variable_get("@#{attr_name}")
  end

  def destroy!
    CWB.sparql(:update).clear_graph(@id)
  end

  def to_hash
    {:id => @id.to_s}
  end
end
