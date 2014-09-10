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
      project_dir = params[3]
      project = params[0]

      # vocab init
      CWB::Vocabulary.fixtures.each do |fix|
        fix.each do |key,val|
         if key == :id
          @label = val
         end
        end

        voc_params = [project, RDF::URI("#{@label}")]

        fix.each_value do |value|
          voc_params << value
        end

        CWB::Vocabulary.turtle_create(voc_params)
      end

      # term init
      CWB::Term.fixtures.each do |fix|
        fix.each do |key,val|
          if key == :id
            @label = val + UUIDTools::UUID.timestamp_create
          end
        end

        voc_params = [project, RDF::URI("#{@label}")]

        fix.each_value do |value|
          voc_params << value
        end

        CWB::Term.turtle_create(voc_params)
      end

      if ::File.directory?(project_dir)
        CWB::Project.create(params)

        Find.find(Pathname(project_dir).to_s) do |path|
          next if path.eql? project_dir

          path = Pathname(path)
          rel_path = Pathname(path.to_s[(project_dir.to_s.size+1)..-1])
          is_toplevel = rel_path.parent.to_s.eql?('.')

          uri = RDF::URI('file:/' + rel_path.to_s)
          name = ::File.basename(path.to_s)

          next if is_toplevel && !path.directory? # we don't support files in the root directory
          next if rel_path.basename.to_s == '.DS_Store' # ignore Mac OS X artifacts
          next if rel_path.basename.to_s == 'Thumbs.db' # ignore Windows artifacts

          if ::File.ftype(path) == 'directory' && path.parent.to_s != '.'
            parent = is_toplevel ? '_null' : rel_path.parent.to_s

            params = [project,uri,name,rel_path.to_s,parent]
            CWB::Folder.create(params)
          elsif ::File.ftype(path) == 'file'
            folder = 'file:/'  + ::File.basename(::File.expand_path("..", path.to_s)).to_s
            created = ::File.ctime(path.to_s).to_datetime.to_s
            size = ::File.size(path.to_s).to_s
            type = FileMagic.new.file(path.to_s).to_s.split(',')[0]
            modified = ::File.mtime(path.to_s).to_datetime.to_s
            starred = 'false'

            params = [project,uri,name,rel_path.to_s,created,size,type,folder,modified,starred]
            CWB::File.create(params)
          end
        end

        { success: true }
      else
        { success: false, error: "Path must be a valid directory" }
      end
    end
  end
end
