require 'find'
require 'rdf/nquads'
require 'date'

module CWB
  class Project < CWB::Resource
    # when passed to .all, :uri is a sparql variable
    # when passed to .each(:project_id), uri is the URI for the project
    def self.graph_pattern(uri=nil,name=nil,description=nil,path=nil)
      [
        [uri||:uri, RDF.type, PIM.Project],
        [uri||:uri, RDF::DC.title, name||:name],
        [uri||:uri, RDF::DC.description, description||:description],
        [uri||:uri, PIM.path, path||:path]
      ]
    end

    def self.project_init(params)
      CWB::Project.create(params)
      project = params[3]

      Find.find(project) do |f|
        project_uri = params[0]
        if ::File.ftype(f) == 'directory' && Pathname(f).parent.to_s != '.'
          uri = RDF::URI('file://' + f)
          name = ::File.basename(f)
          path = ::File.path(f)
          is_part_of = ::File.basename(::File.expand_path("..", Pathname(f).to_s))

          params = [project_uri,uri,name,path,is_part_of]
          
          CWB::Folder.create(params)
        elsif ::File.ftype(f) == 'file'
          uri = RDF::URI('file://' + f)
          name = ::File.basename(f)
          path = ::File.path(f)
          is_part_of = ::File.basename(::File.expand_path("..", Pathname(f).to_s))
          created = ::File.mtime(f).to_datetime
          size = ::File.size(f)
          type = FileMagic.new.file(f)

          params = [project_uri,uri,name,path,is_part_of,created,size,project,type]

          CWB::File.create(params)
        end
      end
    end
  end
end
