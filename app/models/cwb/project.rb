module CWB
  class Project < CWB::Resource
    # when passed to .all, :uri is a sparql variable
    # when passed to .each(:project_id), uri is the URI for the project
    def self.graph_pattern(uri = nil)
      [
        [uri || :uri, RDF.type, PIM.Project],
        [:uri, RDF::DC.title, :name],
        [:uri, RDF::DC.description, :description],
        [:uri, PIM.path, :path]
      ]
    end
  end
end
