module CWB
  class File < CWB::Resource
    def self.graph_pattern(uri=nil)
      [
        [uri||:uri, RDF.type, PIM.File],
        [uri||:uri, PIM.project, :project],
        [uri||:uri, PIM.colocation, :folder],
        [uri||:uri, RDF::DC.title, :name],
        [uri||:uri, RDF::DC.source, :path],
        [uri||:uri, RDF::DC.created, :created],
        [uri||:uri, RDF::DC.extent, :size]
      ]
    end
  end
end
