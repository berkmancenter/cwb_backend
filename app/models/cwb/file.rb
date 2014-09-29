module CWB
  class File < CWB::Resource
    def self.graph_pattern(
      _project=nil,uri=nil,name=nil,path=nil,
      created=nil,size=nil,type=nil,folder=nil,modified=nil,starred=nil,tag=nil
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
        [uri||:uri, PIM.isStarred, starred||:starred],
        [uri||:uri, PIM.tagged, tag||:tag]
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

    def self.tag_file(project_id, file_id, tag_id)
      project = RDF::URI(project_id)
      uri = RDF::URI(file_id)
      tag = RDF::URI(tag_id)

      

      del_params = [project, uri, PIM.tagged, tag]
      create_params = [project, uri, PIM.tagged, tag]

      single_delete(del_params)
      single_create(create_params)
    end

    def self.untag_file(project_id, file_id, tag_id=nil)
      project = RDF::URI(project_id)
      uri = RDF::URI(file_id)
      tag = RDF::URI(tag_id)

      del_params = [project, uri, PIM.tagged, tag]

      single_delete(del_params)
    end

    def self.get_file_description(path)
      self.descriptions_whitelist.each {|definition|
        if Pathname(path.to_s).extname.to_s.downcase == definition[:ext].to_s.downcase
          return definition[:description].to_s
        end
      }

      return FileMagic.new.file(path.to_s).to_s.split(',')[0]
    end

    def self.descriptions_whitelist
      [
        {
          ext: '.max', description: '3D modeling/rendering file'
        },
        {
          ext: '.3dm', description: '2D/3D model file (Rhino)'
        }
      ]
    end
  end
end
