module CWB
  class File < CWB::Resource
    def self.graph_pattern(
                            project_uri=nil,uri=nil,name=nil,path=nil,
                            is_part_of=nil,created=nil,size=nil,project=nil
                          )
      [
        [uri||:uri, RDF.type, PIM.File],
        [uri||:uri, PIM.project, project||:project],
        [uri||:uri, RDF::DC.isPartOf, is_part_of||:is_part_of],
        [uri||:uri, RDF::DC.title, name||:name],
        [uri||:uri, RDF::DC.source, path||:path],
        [uri||:uri, RDF::DC.created, created||:created],
        [uri||:uri, RDF::DC.extent, size||:size]
      ]
    end
  end
end
