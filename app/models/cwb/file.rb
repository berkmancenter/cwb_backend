module CWB
  class File < CWB::Resource
    def self.graph_pattern(
                            _project=nil,uri=nil,name=nil,path=nil,
                            created=nil,size=nil,type=nil,folder=nil,modified=nil
                          )
      [
        [uri||:uri, RDF.type, PIM.File],
        [uri||:uri, RDF::DC.title, name||:name],
        [uri||:uri, RDF::DC.source, path||:path],
        [uri||:uri, RDF::DC.created, created||:created],
        [uri||:uri, RDF::DC.extent, size||:size],
        [uri||:uri, RDF::FOAF.name, type||:type],
        [uri||:uri, PIM.colocation, folder||:folder],
        [uri||:uri, RDF::DC.modified, modified||:modified]
      ]
    end
  end
end
