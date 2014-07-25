module CWB
  class Project < CWB::Resource
   def self.pattern
     [
       [:resource, RDF.type, PIM.Project],
       [:resource, RDF::DC.title, :name],
       [:resource, RDF::DC.description, :description],
       [:resource, PIM.path, :path]
     ].freeze
   end

    def self.query(graph = nil, options = {})
      super(graph, options).order_by(:name)
    end

    def self.graph_uri
      CWB::BASE_URI.join(UUIDTools::UUID.timestamp_create.to_s)
    end

    def to_hash
      super.merge(
        name: @name.to_s,
        description: @description.to_s,
        path: @path.to_s
      )
    end
  end
end
