module CWB
  class Folder < CWB::Node
    def self.graph_pattern(uri = nil)
      [
        [:uri, RDF.type, PIM.Directory],
        [:uri, PIM.project, :project],
        [:uri, RDF::DC.title, :name],
        [:uri, RDF::DC.source, :path]
      ]
    end
  end
end
