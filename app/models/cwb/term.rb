module CWB
  class Term < CWB::Resource
    attr_accessor :label, :description
    def self.graph_pattern(_project=nil,uri=nil,label=nil,vocab=nil,description=nil)
      [
        [uri||:uri, RDF.type, PIM.Term],
        [uri||:uri, RDF::DC.title, label||:label],
        [uri||:uri, RDF::DC.description, description||:description],
        [uri||:uri, RDF::DC.isPartOf, vocab||:vocab]
      ]
    end

    def self.term_delete(params)
      del_params = []
      project_uri = RDF::URI(params[0])
      graph_pattern(*params).each do |triple|
        del_params << project_uri
        del_params << triple
        del_params.flatten!
        full_tag_delete(project_uri, del_params[1])
        single_delete(del_params)
        del_params = []
      end
    end

    def self.full_tag_delete(project_uri, tag)
      project_id = project_uri.to_s
      files = CWB::File.nested_all(project_id, vocab_uri=nil, tagged=true)
      files.each do |i|
        file_uri = RDF::URI(i[:id])

        del_params = [project_uri, file_uri, PIM.tagged, tag]

        single_delete(del_params)
      end
    end

    def self.fixtures
      [
        { id: "Unknown"                 , vocabulary: CWB::BASE_URI + 'Format'                    , description: '' } ,
        { id: "Does__not__apply"        , vocabulary: CWB::BASE_URI + 'Format'                    , description: '' } ,
        { id: "Agreement"               , vocabulary: CWB::BASE_URI + 'Document__Type'            , description: '' } ,
        { id: "Audio/Video"             , vocabulary: CWB::BASE_URI + 'Document__Type'            , description: '' } ,
        { id: "Communication"           , vocabulary: CWB::BASE_URI + 'Document__Type'            , description: '' } ,
        { id: "Drawing"                 , vocabulary: CWB::BASE_URI + 'Document__Type'            , description: '' } ,
        { id: "Index"                   , vocabulary: CWB::BASE_URI + 'Document__Type'            , description: '' } ,
        { id: "Log"                     , vocabulary: CWB::BASE_URI + 'Document__Type'            , description: '' } ,
        { id: "Model"                   , vocabulary: CWB::BASE_URI + 'Document__Type'            , description: '' } ,
        { id: "Other"                   , vocabulary: CWB::BASE_URI + 'Document__Type'            , description: '' } ,
        { id: "Photograph"              , vocabulary: CWB::BASE_URI + 'Document__Type'            , description: '' } ,
        { id: "Presentation"            , vocabulary: CWB::BASE_URI + 'Document__Type'            , description: '' } ,
        { id: "Product__brochure"       , vocabulary: CWB::BASE_URI + 'Document__Type'            , description: '' } ,
        { id: "Project__book"           , vocabulary: CWB::BASE_URI + 'Document__Type'            , description: '' } ,
        { id: "Rendering"               , vocabulary: CWB::BASE_URI + 'Document__Type'            , description: '' } ,
        { id: "Schedule"                , vocabulary: CWB::BASE_URI + 'Document__Type'            , description: '' } ,
        { id: "Sketch"                  , vocabulary: CWB::BASE_URI + 'Document__Type'            , description: '' } ,
        { id: "Specification"           , vocabulary: CWB::BASE_URI + 'Document__Type'            , description: '' } ,
        { id: "Study"                   , vocabulary: CWB::BASE_URI + 'Document__Type'            , description: '' } ,
        { id: "Work__file"              , vocabulary: CWB::BASE_URI + 'Document__Type'            , description: '' } ,
        { id: "Unknown"                 , vocabulary: CWB::BASE_URI + 'Zone'                      , description: '' } ,
        { id: "Does__not__apply"        , vocabulary: CWB::BASE_URI + 'Zone'                      , description: '' } ,
        { id: "Unknown"                 , vocabulary: CWB::BASE_URI + 'Phase'                     , description: '' } ,
        { id: "Does__not__apply"        , vocabulary: CWB::BASE_URI + 'Phase'                     , description: '' } ,
        { id: "Architecture"            , vocabulary: CWB::BASE_URI + 'Architectural__Discipline' , description: '' } ,
        { id: "Audiovisual"             , vocabulary: CWB::BASE_URI + 'Architectural__Discipline' , description: '' } ,
        { id: "Civil"                   , vocabulary: CWB::BASE_URI + 'Architectural__Discipline' , description: '' } ,
        { id: "Electrical"              , vocabulary: CWB::BASE_URI + 'Architectural__Discipline' , description: '' } ,
        { id: "Food__service"           , vocabulary: CWB::BASE_URI + 'Architectural__Discipline' , description: '' } ,
        { id: "Geotechnical"            , vocabulary: CWB::BASE_URI + 'Architectural__Discipline' , description: '' } ,
        { id: "Info__tech"              , vocabulary: CWB::BASE_URI + 'Architectural__Discipline' , description: '' } ,
        { id: "Interiors"               , vocabulary: CWB::BASE_URI + 'Architectural__Discipline' , description: '' } ,
        { id: "Landscape"               , vocabulary: CWB::BASE_URI + 'Architectural__Discipline' , description: '' } ,
        { id: "Lightning"               , vocabulary: CWB::BASE_URI + 'Architectural__Discipline' , description: '' } ,
        { id: "Mechanical"              , vocabulary: CWB::BASE_URI + 'Architectural__Discipline' , description: '' } ,
        { id: "Plumbing"                , vocabulary: CWB::BASE_URI + 'Architectural__Discipline' , description: '' } ,
        { id: "Security"                , vocabulary: CWB::BASE_URI + 'Architectural__Discipline' , description: '' } ,
        { id: "Signage"                 , vocabulary: CWB::BASE_URI + 'Architectural__Discipline' , description: '' } ,
        { id: "Structural"              , vocabulary: CWB::BASE_URI + 'Architectural__Discipline' , description: '' } ,
        { id: "Unknown"                 , vocabulary: CWB::BASE_URI + 'Architectural__Discipline' , description: '' } ,
        { id: "Does__not__apply"        , vocabulary: CWB::BASE_URI + 'Architectural__Discipline' , description: '' } ,
        { id: "Default__access__policy" , vocabulary: CWB::BASE_URI + 'Rights'                    , description: '' }
      ] 
    end
  end
end
