module CWB
  class Project < CWB::Resource
    PATTERN = [
      [:resource, RDF.type, PIM.Project],
      [:resource, RDF::DC.title, :name],
      [:resource, RDF::DC.description, :description],
      [:resource, PIM.path, :path]
    ].freeze

    def self.query(graph = nil, options = {})
      super(graph, options).order_by(:name)
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
