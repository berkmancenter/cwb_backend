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
      project_dir = params[3]

      Find.find(Pathname(project_dir).to_s) do |path|
        next if path.eql? project_dir

        t_path = Pathname(path[(project_dir.to_s.size+1)..-1])

        project = params[0]

        if ::File.ftype(path) == 'directory' && Pathname(path).parent.to_s != '.'
          uri = RDF::URI('file:/' + t_path.to_s)
          name = ::File.basename(path.to_s)
          # is_part_of = ::File.basename(::File.expand_path("..", Pathname(path.to_s).to_s))
          is_toplevel = t_path.parent.to_s.eql?('.')
          parent = is_toplevel ? '_null' : t_path.parent.to_s

          # if parent.parent.to_s.eql?('.')
          #   parent = nil
          # else
          #   parent = parent.parent.to_s
          # end

          params = [project,uri,name,t_path.to_s,parent]
          
          CWB::Folder.create(params)
        elsif ::File.ftype(path) == 'file'
          uri = RDF::URI('file:/' + t_path.to_s)
          name = ::File.basename(path.to_s)
          folder = 'file:/'  + ::File.basename(::File.expand_path("..", Pathname(path).to_s)).to_s
          created = ::File.ctime(path.to_s).to_datetime.to_s
          size = ::File.size(path.to_s).to_s
          type = FileMagic.new.file(path)
          modified = ::File.mtime(path.to_s).to_datetime.to_s

          params = [project,uri,name,t_path.to_s,created,size,type,folder,modified]
          CWB::File.create(params)
        end
      end
    

    # Find.find(project_dir) do |path|
    #   next if path.eql?(project_dir)

    #   path = Pathname(path)
    #   binding.pry
    #   rel_path = Pathname(path.to_s[(project_dir.to_s.size+1)..-1])
    #   binding.pry
    #   is_toplevel = rel_path.parent.to_s.eql?('.')
    #   binding.pry

    #   # puts "Processing: #{rel_path}"
    #   next if is_toplevel && !path.directory? # we don't support files in the root directory
    #   # next if rel_path.basename.to_s == '.DS_Store' # ignore Mac OS X artifacts
    #   # next if rel_path.basename.to_s == 'Thumbs.db' # ignore Windows artifacts

    #   resource = RDF::URI('file://' + rel_path.to_s)
    #   parent_resource = is_toplevel ? nil : RDF::URI('file://' + rel_path.parent.to_s)
    #   binding.pry

    #   case path_type = path.ftype.to_sym
    #     when :directory

    #     when :file
    #       
    #     end
    #   end


    end
  end
end
