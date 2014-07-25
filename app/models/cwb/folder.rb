module CWB
  class Folder < CWB::Node
    PATTERN = [
      [:resource, RDF.type, PIM.Directory],
      [:resource, PIM.project, :project],
      [:resource, RDF::DC.title, :name],
      [:resource, RDF::DC.source, :path]
    ].freeze

    OPTIONAL = [
      [:resource, PIM.colocation, :parent]
    ].freeze

    def to_hash
      super.merge(
        project: @project.to_s,
        parent: @parent ? @parent.to_s : nil,
        name: @name.to_s,
        path: @path.to_s
      )
    end
  end
end
