module CWB
  class Folder < CWB::Resource
    def self.graph_pattern(
                            project_uri=nil,uri=nil,
                            name=nil,path=nil,is_part_of=nil
                          )
      [
        [uri||:uri, RDF.type, PIM.Directory],
        [uri||:uri, PIM.project, project_uri||:project_uri],
        [uri||:uri, RDF::DC.title, name||:name],
        [uri||:uri, RDF::DC.source, path||:path],
        [uri||:uri, RDF::DC.isPartOf, is_part_of||:is_part_of]
      ]
    end
  end
end
