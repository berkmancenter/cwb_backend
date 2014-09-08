module CWB
  class Vocabulary < CWB::Resource
    def self.graph_pattern(_project=nil,uri=nil,label=nil,description=nil)
      [
        [uri||:uri, RDF.type, PIM.Vocabulary],
        [uri||:uri, RDF::DC.title, label||:label],
        [uri||:uri, RDF::DC.description, description||:description]
      ]
    end

    def self.fixtures
      [
        { id: "Format", description: "null" },
        { id: "Document Type", description: "null" },
        { id: "Zone", description: "Physical area of the building represented." },
        { id: "Phase", description: "Temporal section of project activities this file belongs to." },
        { id: "Architectural Discipline", description: "Area of technical specialty to which this resource belongs." },
        { id: "Rights", description: "Access control policy, documents read access and/or embargo." }
      ]
    end
  end
end
