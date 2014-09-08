module CWB
  class Term < CWB::Resource
    def self.graph_pattern(_project=nil,uri=nil,label=nil,vocab=nil,description=nil)
      [
        [uri||:uri, RDF.type, PIM.Term],
        [uri||:uri, RDF::DC.title, label||:label],
        [uri||:uri, RDF::DC.description, description||:description],
        [uri||:uri, RDF::DC.isPartOf, vocab||:vocab]
      ]
    end

    def self.fixtures
      [
        { id: "Unknown"             , vocabulary: RDF::URI('http://facade.mit.edu/dataset/Format')                 , description: 'null' } ,
        { id: "DoesNotApply"        , vocabulary: RDF::URI('http://facade.mit.edu/dataset/Format')                 , description: 'null' } ,
        { id: "Agreement"           , vocabulary: RDF::URI('http://facade.mit.edu/dataset/DocumentType')           , description: 'null' } ,
        { id: "Audio/Video"         , vocabulary: RDF::URI('http://facade.mit.edu/dataset/DocumentType')           , description: 'null' } ,
        { id: "Communication"       , vocabulary: RDF::URI('http://facade.mit.edu/dataset/DocumentType')           , description: 'null' } ,
        { id: "Drawing"             , vocabulary: RDF::URI('http://facade.mit.edu/dataset/DocumentType')           , description: 'null' } ,
        { id: "Index"               , vocabulary: RDF::URI('http://facade.mit.edu/dataset/DocumentType')           , description: 'null' } ,
        { id: "Log"                 , vocabulary: RDF::URI('http://facade.mit.edu/dataset/DocumentType')           , description: 'null' } ,
        { id: "Model"               , vocabulary: RDF::URI('http://facade.mit.edu/dataset/DocumentType')           , description: 'null' } ,
        { id: "Other"               , vocabulary: RDF::URI('http://facade.mit.edu/dataset/DocumentType')           , description: 'null' } ,
        { id: "Photograph"          , vocabulary: RDF::URI('http://facade.mit.edu/dataset/DocumentType')           , description: 'null' } ,
        { id: "Presentation"        , vocabulary: RDF::URI('http://facade.mit.edu/dataset/DocumentType')           , description: 'null' } ,
        { id: "ProductBrochure"     , vocabulary: RDF::URI('http://facade.mit.edu/dataset/DocumentType')           , description: 'null' } ,
        { id: "ProjectBook"         , vocabulary: RDF::URI('http://facade.mit.edu/dataset/DocumentType')           , description: 'null' } ,
        { id: "Rendering"           , vocabulary: RDF::URI('http://facade.mit.edu/dataset/DocumentType')           , description: 'null' } ,
        { id: "Schedule"            , vocabulary: RDF::URI('http://facade.mit.edu/dataset/DocumentType')           , description: 'null' } ,
        { id: "Sketch"              , vocabulary: RDF::URI('http://facade.mit.edu/dataset/DocumentType')           , description: 'null' } ,
        { id: "Specification"       , vocabulary: RDF::URI('http://facade.mit.edu/dataset/DocumentType')           , description: 'null' } ,
        { id: "Study"               , vocabulary: RDF::URI('http://facade.mit.edu/dataset/DocumentType')           , description: 'null' } ,
        { id: "WorkFile"            , vocabulary: RDF::URI('http://facade.mit.edu/dataset/DocumentType')           , description: 'null' } ,
        { id: "Unknown"             , vocabulary: RDF::URI('http://facade.mit.edu/dataset/Zone')                   , description: 'null' } ,
        { id: "DoesNotApply"        , vocabulary: RDF::URI('http://facade.mit.edu/dataset/Zone')                   , description: 'null' } ,
        { id: "Unknown"             , vocabulary: RDF::URI('http://facade.mit.edu/dataset/Phase')                  , description: 'null' } ,
        { id: "DoesNotApply"        , vocabulary: RDF::URI('http://facade.mit.edu/dataset/Phase')                  , description: 'null' } ,
        { id: "Architecture"        , vocabulary: RDF::URI('http://facade.mit.edu/dataset/ArcitecturalDiscipline') , description: 'null' } ,
        { id: "Audiovisual"         , vocabulary: RDF::URI('http://facade.mit.edu/dataset/ArcitecturalDiscipline') , description: 'null' } ,
        { id: "Civil"               , vocabulary: RDF::URI('http://facade.mit.edu/dataset/ArcitecturalDiscipline') , description: 'null' } ,
        { id: "Electrical"          , vocabulary: RDF::URI('http://facade.mit.edu/dataset/ArcitecturalDiscipline') , description: 'null' } ,
        { id: "FoodService"         , vocabulary: RDF::URI('http://facade.mit.edu/dataset/ArcitecturalDiscipline') , description: 'null' } ,
        { id: "Geotechnical"        , vocabulary: RDF::URI('http://facade.mit.edu/dataset/ArcitecturalDiscipline') , description: 'null' } ,
        { id: "InfoTech"            , vocabulary: RDF::URI('http://facade.mit.edu/dataset/ArcitecturalDiscipline') , description: 'null' } ,
        { id: "Interiors"           , vocabulary: RDF::URI('http://facade.mit.edu/dataset/ArcitecturalDiscipline') , description: 'null' } ,
        { id: "Landscape"           , vocabulary: RDF::URI('http://facade.mit.edu/dataset/ArcitecturalDiscipline') , description: 'null' } ,
        { id: "Lightning"           , vocabulary: RDF::URI('http://facade.mit.edu/dataset/ArcitecturalDiscipline') , description: 'null' } ,
        { id: "Mechanical"          , vocabulary: RDF::URI('http://facade.mit.edu/dataset/ArcitecturalDiscipline') , description: 'null' } ,
        { id: "Plumbing"            , vocabulary: RDF::URI('http://facade.mit.edu/dataset/ArcitecturalDiscipline') , description: 'null' } ,
        { id: "Security"            , vocabulary: RDF::URI('http://facade.mit.edu/dataset/ArcitecturalDiscipline') , description: 'null' } ,
        { id: "Signage"             , vocabulary: RDF::URI('http://facade.mit.edu/dataset/ArcitecturalDiscipline') , description: 'null' } ,
        { id: "Structural"          , vocabulary: RDF::URI('http://facade.mit.edu/dataset/ArcitecturalDiscipline') , description: 'null' } ,
        { id: "Unknown"             , vocabulary: RDF::URI('http://facade.mit.edu/dataset/ArcitecturalDiscipline') , description: 'null' } ,
        { id: "DoesNotApply"        , vocabulary: RDF::URI('http://facade.mit.edu/dataset/ArcitecturalDiscipline') , description: 'null' } ,
        { id: "DefaultAccessPolicy" , vocabulary: RDF::URI('http://facade.mit.edu/dataset/Rights')                 , description: 'null' }
      ] 
    end
  end
end
