module CWB
  class Folder < CWB::Resource
    def self.graph_pattern(
                            project=nil,uri=nil,
                            name=nil,path=nil,parent=nil
                          )
      [
        [uri||:uri, RDF.type, PIM.Directory],
        [uri||:uri, PIM.project, project||:project],
        [uri||:uri, RDF::DC.title, name||:name],
        [uri||:uri, RDF::DC.source, path||:path],
        [uri||:uri, PIM.colocation, parent||:parent]
      ]
    end
  end
end
