module CWB
  class Term < CWB::Resource
    attr_accessor :label, :description
    def self.graph_pattern(_project=nil,uri=nil,label=nil,vocab=nil,description=nil,locked=nil)
      [
        [uri||:uri, RDF.type, PIM.Term],
        [uri||:uri, RDF::DC.title, label||:label],
        [uri||:uri, RDF::DC.description, description||:description],
        [uri||:uri, RDF::DC.isPartOf, vocab||:vocab],
        [uri||:uri, PIM.locked, locked||:locked]
      ]
    end

    def self.term_delete(params)
      del_params = []
      project_uri = RDF::URI(params[0])
      graph_pattern(*params).each do |triple|
        del_params << project_uri
        del_params << triple
        del_params.flatten!
        single_delete(del_params)
        del_params = []
      end
    end

    def self.file_tag_delete(project_uri, old_tag)
      project_id = project_uri.to_s
      files_query = CWB.sparql.select.graph(project_id).where([:uri, PIM.tagged, old_tag])
      files = files_query.execute
      files.each do |i|
        file_uri = RDF::URI(i[:uri])
        del_params = [project_uri, file_uri, PIM.tagged, old_tag]
        single_delete(del_params)
      end
      files
    end

    def self.file_tag_create(project_uri, new_tag, files)
      project_id = project_uri.to_s
      files.bindings[:uri].each do |i|
        create_params = [project_uri, i, PIM.tagged, new_tag]
        single_create(create_params)
      end if files.bindings[:uri]
    end

    def self.fixtures
      [
        { id: "Architecture",                   vocabulary: CWB::BASE_URI + "Architectural__Discipline",        description: "", locked: 'true' },
        { id: "Landscape__arch.",               vocabulary: CWB::BASE_URI + "Architectural__Discipline",        description: "", locked: 'true' },
        { id: "Urban__design",                  vocabulary: CWB::BASE_URI + "Architectural__Discipline",        description: "", locked: 'true' },
        { id: "Urban__planning",                vocabulary: CWB::BASE_URI + "Architectural__Discipline",        description: "", locked: 'true' },
        { id: "Master__planning",               vocabulary: CWB::BASE_URI + "Architectural__Discipline",        description: "", locked: 'true' },
        { id: "Site__surveying",                vocabulary: CWB::BASE_URI + "Architectural__Discipline",        description: "", locked: 'true' },
        { id: "Cost__estimation",               vocabulary: CWB::BASE_URI + "Architectural__Discipline",        description: "", locked: 'true' },
        { id: "Value__eng.",                    vocabulary: CWB::BASE_URI + "Architectural__Discipline",        description: "", locked: 'true' },
        { id: "Proposal__preparation",          vocabulary: CWB::BASE_URI + "Architectural__Discipline",        description: "", locked: 'true' },
        { id: "Scheduling",                     vocabulary: CWB::BASE_URI + "Architectural__Discipline",        description: "", locked: 'true' },
        { id: "Structural__eng.",               vocabulary: CWB::BASE_URI + "Architectural__Discipline",        description: "", locked: 'true' },
        { id: "Mechanical__eng.",               vocabulary: CWB::BASE_URI + "Architectural__Discipline",        description: "", locked: 'true' },
        { id: "Plumbing__eng.",                 vocabulary: CWB::BASE_URI + "Architectural__Discipline",        description: "", locked: 'true' },
        { id: "HVAC__eng.",                     vocabulary: CWB::BASE_URI + "Architectural__Discipline",        description: "", locked: 'true' },
        { id: "Electrical__eng.",               vocabulary: CWB::BASE_URI + "Architectural__Discipline",        description: "", locked: 'true' },
        { id: "Lighting__design",               vocabulary: CWB::BASE_URI + "Architectural__Discipline",        description: "", locked: 'true' },
        { id: "Fire__protection__eng.",         vocabulary: CWB::BASE_URI + "Architectural__Discipline",        description: "", locked: 'true' },
        { id: "Alarm__and__detection__eng.",    vocabulary: CWB::BASE_URI + "Architectural__Discipline",        description: "", locked: 'true' },
        { id: "Irrigation__design",             vocabulary: CWB::BASE_URI + "Architectural__Discipline",        description: "", locked: 'true' },
        { id: "Interior__design",               vocabulary: CWB::BASE_URI + "Architectural__Discipline",        description: "", locked: 'true' },
        { id: "Graphic__design",                vocabulary: CWB::BASE_URI + "Architectural__Discipline",        description: "", locked: 'true' },
        { id: "Contract__administration",       vocabulary: CWB::BASE_URI + "Architectural__Discipline",        description: "", locked: 'true' },
        { id: "General__contracting",           vocabulary: CWB::BASE_URI + "Architectural__Discipline",        description: "", locked: 'true' },
        { id: "Subcontracting",                 vocabulary: CWB::BASE_URI + "Architectural__Discipline",        description: "", locked: 'true' },
        { id: "Construction__mgmt.",            vocabulary: CWB::BASE_URI + "Architectural__Discipline",        description: "", locked: 'true' },
        { id: "Environmental__impact",          vocabulary: CWB::BASE_URI + "Architectural__Discipline",        description: "", locked: 'true' },

        { id: "Contracts",                      vocabulary: CWB::BASE_URI + "Document__Type",                   description: "", locked: 'true' },
        { id: "Texts__(doc.__genre)",           vocabulary: CWB::BASE_URI + "Document__Type",                   description: "", locked: 'true' },
        { id: "Correspondence",                 vocabulary: CWB::BASE_URI + "Document__Type",                   description: "", locked: 'true' },
        { id: "Specifications",                 vocabulary: CWB::BASE_URI + "Document__Type",                   description: "", locked: 'true' },
        { id: "Audiovisual__materials",         vocabulary: CWB::BASE_URI + "Document__Type",                   description: "", locked: 'true' },
        { id: "Photographs",                    vocabulary: CWB::BASE_URI + "Document__Type",                   description: "", locked: 'true' },
        { id: "Surveys__(documents)",           vocabulary: CWB::BASE_URI + "Document__Type",                   description: "", locked: 'true' },
        { id: "Studies__(visual__works)",       vocabulary: CWB::BASE_URI + "Document__Type",                   description: "", locked: 'true' },
        { id: "Schedules__(arch.__dwgs.)",      vocabulary: CWB::BASE_URI + "Document__Type",                   description: "", locked: 'true' },
        { id: "Sketches",                       vocabulary: CWB::BASE_URI + "Document__Type",                   description: "", locked: 'true' },
        { id: "Plans__(orthogr.__proj.)",       vocabulary: CWB::BASE_URI + "Document__Type",                   description: "", locked: 'true' },
        { id: "Floor__plans",                   vocabulary: CWB::BASE_URI + "Document__Type",                   description: "", locked: 'true' },
        { id: "Sections__(orthogr.__proj.)",    vocabulary: CWB::BASE_URI + "Document__Type",                   description: "", locked: 'true' },
        { id: "Elevations__(orthogr.__proj.)",  vocabulary: CWB::BASE_URI + "Document__Type",                   description: "", locked: 'true' },
        { id: "Interior__elevations",           vocabulary: CWB::BASE_URI + "Document__Type",                   description: "", locked: 'true' },
        { id: "Renderings__(dwgs.)",            vocabulary: CWB::BASE_URI + "Document__Type",                   description: "", locked: 'true' },
        { id: "Wireframe__dwgs.",               vocabulary: CWB::BASE_URI + "Document__Type",                   description: "", locked: 'true' },
        { id: "Models__(representations)",      vocabulary: CWB::BASE_URI + "Document__Type",                   description: "", locked: 'true' },
        { id: "3D__Computer__models",           vocabulary: CWB::BASE_URI + "Document__Type",                   description: "", locked: 'true' },
        { id: "Computer__animations",           vocabulary: CWB::BASE_URI + "Document__Type",                   description: "", locked: 'true' },
        { id: "Axonometric__proj.",             vocabulary: CWB::BASE_URI + "Document__Type",                   description: "", locked: 'true' },
        { id: "Perspective__proj.",             vocabulary: CWB::BASE_URI + "Document__Type",                   description: "", locked: 'true' },

        { id: "Conceptual__design",             vocabulary: CWB::BASE_URI + "Phase",                            description: "", locked: 'true' },
        { id: "Schematic__design",              vocabulary: CWB::BASE_URI + "Phase",                            description: "", locked: 'true' },
        { id: "Preliminary__design",            vocabulary: CWB::BASE_URI + "Phase",                            description: "", locked: 'true' },
        { id: "(Alternative)__design",          vocabulary: CWB::BASE_URI + "Phase",                            description: "", locked: 'true' },
        { id: "Design__development",            vocabulary: CWB::BASE_URI + "Phase",                            description: "", locked: 'true' },
        { id: "Value__analysis",                vocabulary: CWB::BASE_URI + "Phase",                            description: "", locked: 'true' },
        { id: "Specifications__preparation",    vocabulary: CWB::BASE_URI + "Phase",                            description: "", locked: 'true' },
        { id: "Construction__documents",        vocabulary: CWB::BASE_URI + "Phase",                            description: "", locked: 'true' },
        { id: "Bidding",                        vocabulary: CWB::BASE_URI + "Phase",                            description: "", locked: 'true' },
        { id: "Scheduling",                     vocabulary: CWB::BASE_URI + "Phase",                            description: "", locked: 'true' },
        { id: "Contract__execution",            vocabulary: CWB::BASE_URI + "Phase",                            description: "", locked: 'true' },
        { id: "Construction__phase",            vocabulary: CWB::BASE_URI + "Phase",                            description: "", locked: 'true' },
        { id: "Close__of__construction",        vocabulary: CWB::BASE_URI + "Phase",                            description: "", locked: 'true' },

        { id: "Default__Access__Policy",        vocabulary: CWB::BASE_URI + "Rights",                           description: "", locked: 'true' },
        { id: "Not__Embargoed",                 vocabulary: CWB::BASE_URI + "Rights",                           description: "", locked: 'true' },
        { id: "Embargoed__3__years",            vocabulary: CWB::BASE_URI + "Rights",                           description: "", locked: 'true' },
        { id: "Embargoed__5__years",            vocabulary: CWB::BASE_URI + "Rights",                           description: "", locked: 'true' },
        { id: "Embargoed__10__years",           vocabulary: CWB::BASE_URI + "Rights",                           description: "", locked: 'true' },
        { id: "Embargoed__20__years",           vocabulary: CWB::BASE_URI + "Rights",                           description: "", locked: 'true' }
      ]
    end
  end
end
