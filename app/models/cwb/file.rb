module CWB
  class File < CWB::Resource
    def self.graph_pattern(
      _project=nil,uri=nil,name=nil,path=nil,
      created=nil,size=nil,type=nil,folder=nil,modified=nil,starred=nil
    )
      [
        [uri||:uri, RDF.type, PIM.File],
        [uri||:uri, RDF::DC.title, name||:name],
        [uri||:uri, RDF::DC.source, path||:path],
        [uri||:uri, RDF::DC.created, created||:created],
        [uri||:uri, RDF::DC.extent, size||:size],
        [uri||:uri, RDF::FOAF.name, type||:type],
        [uri||:uri, PIM.colocation, folder||:folder],
        [uri||:uri, RDF::DC.modified, modified||:modified],
        [uri||:uri, PIM.isStarred, starred||:starred]
      ]
    end

    def self.unmark_starred(file_id, project_id)
      project = RDF::URI(project_id)
      uri = RDF::URI(file_id)

      del_params = [project, uri, PIM.isStarred, 'true']
      create_params = [project, uri, PIM.isStarred, 'false']

      single_delete(del_params)
      single_create(create_params)
    end

    def self.mark_starred(file_id, project_id)
      project = RDF::URI(project_id)
      uri = RDF::URI(file_id)

      del_params = [project, uri, PIM.isStarred, 'false']
      create_params = [project, uri, PIM.isStarred, 'true']

      single_delete(del_params)
      single_create(create_params)
    end
  end
end