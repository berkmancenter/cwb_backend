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
        { id: "Unknown"                 , vocabulary: CWB::BASE_URI + 'Format'                    , description: '' } ,
        { id: "Does__not__apply"        , vocabulary: CWB::BASE_URI + 'Format'                    , description: '' } ,
        { id: "Agreement"               , vocabulary: CWB::BASE_URI + 'Document__type'            , description: '' } ,
        { id: "Audio/Video"             , vocabulary: CWB::BASE_URI + 'Document__type'            , description: '' } ,
        { id: "Communication"           , vocabulary: CWB::BASE_URI + 'Document__type'            , description: '' } ,
        { id: "Drawing"                 , vocabulary: CWB::BASE_URI + 'Document__type'            , description: '' } ,
        { id: "Index"                   , vocabulary: CWB::BASE_URI + 'Document__type'            , description: '' } ,
        { id: "Log"                     , vocabulary: CWB::BASE_URI + 'Document__type'            , description: '' } ,
        { id: "Model"                   , vocabulary: CWB::BASE_URI + 'Document__type'            , description: '' } ,
        { id: "Other"                   , vocabulary: CWB::BASE_URI + 'Document__type'            , description: '' } ,
        { id: "Photograph"              , vocabulary: CWB::BASE_URI + 'Document__type'            , description: '' } ,
        { id: "Presentation"            , vocabulary: CWB::BASE_URI + 'Document__type'            , description: '' } ,
        { id: "Product__brochure"       , vocabulary: CWB::BASE_URI + 'Document__type'            , description: '' } ,
        { id: "Project__book"           , vocabulary: CWB::BASE_URI + 'Document__type'            , description: '' } ,
        { id: "Rendering"               , vocabulary: CWB::BASE_URI + 'Document__type'            , description: '' } ,
        { id: "Schedule"                , vocabulary: CWB::BASE_URI + 'Document__type'            , description: '' } ,
        { id: "Sketch"                  , vocabulary: CWB::BASE_URI + 'Document__type'            , description: '' } ,
        { id: "Specification"           , vocabulary: CWB::BASE_URI + 'Document__type'            , description: '' } ,
        { id: "Study"                   , vocabulary: CWB::BASE_URI + 'Document__type'            , description: '' } ,
        { id: "Work__file"              , vocabulary: CWB::BASE_URI + 'Document__type'            , description: '' } ,
        { id: "Unknown"                 , vocabulary: CWB::BASE_URI + 'Zone'                      , description: '' } ,
        { id: "Does__not__apply"        , vocabulary: CWB::BASE_URI + 'Zone'                      , description: '' } ,
        { id: "Unknown"                 , vocabulary: CWB::BASE_URI + 'Phase'                     , description: '' } ,
        { id: "Does__not__apply"        , vocabulary: CWB::BASE_URI + 'Phase'                     , description: '' } ,
        { id: "Architecture"            , vocabulary: CWB::BASE_URI + 'Architectural__discipline' , description: '' } ,
        { id: "Audiovisual"             , vocabulary: CWB::BASE_URI + 'Architectural__discipline' , description: '' } ,
        { id: "Civil"                   , vocabulary: CWB::BASE_URI + 'Architectural__discipline' , description: '' } ,
        { id: "Electrical"              , vocabulary: CWB::BASE_URI + 'Architectural__discipline' , description: '' } ,
        { id: "Food__service"           , vocabulary: CWB::BASE_URI + 'Architectural__discipline' , description: '' } ,
        { id: "Geotechnical"            , vocabulary: CWB::BASE_URI + 'Architectural__discipline' , description: '' } ,
        { id: "Info__tech"              , vocabulary: CWB::BASE_URI + 'Architectural__discipline' , description: '' } ,
        { id: "Interiors"               , vocabulary: CWB::BASE_URI + 'Architectural__discipline' , description: '' } ,
        { id: "Landscape"               , vocabulary: CWB::BASE_URI + 'Architectural__discipline' , description: '' } ,
        { id: "Lightning"               , vocabulary: CWB::BASE_URI + 'Architectural__discipline' , description: '' } ,
        { id: "Mechanical"              , vocabulary: CWB::BASE_URI + 'Architectural__discipline' , description: '' } ,
        { id: "Plumbing"                , vocabulary: CWB::BASE_URI + 'Architectural__discipline' , description: '' } ,
        { id: "Security"                , vocabulary: CWB::BASE_URI + 'Architectural__discipline' , description: '' } ,
        { id: "Signage"                 , vocabulary: CWB::BASE_URI + 'Architectural__discipline' , description: '' } ,
        { id: "Structural"              , vocabulary: CWB::BASE_URI + 'Architectural__discipline' , description: '' } ,
        { id: "Unknown"                 , vocabulary: CWB::BASE_URI + 'Architectural__discipline' , description: '' } ,
        { id: "Does__not__apply"        , vocabulary: CWB::BASE_URI + 'Architectural__discipline' , description: '' } ,
        { id: "Default__access__policy" , vocabulary: CWB::BASE_URI + 'Rights'                    , description: '' }
      ] 
    end
  end
end
