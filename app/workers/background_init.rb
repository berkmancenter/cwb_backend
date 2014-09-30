require 'fileutils'

class BackgroundInit
  include Sidekiq::Worker

  attr_reader :errors

  def initialize
    @errors = []
  end

  def validate!(name, descript, path, email)
    if !::File.directory?(path)
      @errors << "Path must be a valid directory"
    end

    return @errors.empty?
  end

  def perform(name, descript, path, email)
    uri = RDF::URI(CWB::BASE_URI.to_s + name)

    project_params = [uri, name, descript, path]
    project_dir = project_params[3]
    project = project_params[0]
    project_name = project.to_s.sub(CWB::BASE_URI.to_s, '')

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

    Find.find(Pathname(project_dir).to_s) do |path|
      next if path.eql? project_dir

      project_root = Pathname(project_dir).basename
      path = Pathname(path)
      name = ::File.basename(path.to_s)

      rel_path = Pathname(path.to_s[(project_dir.to_s.size-project_root.to_s.size)..-1])
      is_toplevel = name == path.to_s[(project_dir.to_s.size+1)..-1]

      uri = RDF::URI('file:/' + rel_path.to_s)

      next if is_toplevel && !path.directory? # we don't support files in the root directory
      next if rel_path.basename.to_s == '.DS_Store' # ignore Mac OS X artifacts
      next if rel_path.basename.to_s == 'Thumbs.db' # ignore Windows artifacts

      if ::File.ftype(path) == 'directory' && path.parent.to_s != '.'
        parent = is_toplevel ? '_null' : 'file:/' + rel_path.parent.to_s

        folder_params = [project,uri,name,rel_path.to_s,parent]
        CWB::Folder.create(folder_params)
      elsif ::File.ftype(path) == 'file'
        folder = 'file:/'  + rel_path.parent.to_s
        created = ::File.ctime(path.to_s).to_datetime.to_s
        size = ::File.size(path.to_s).to_s

        type_full = FileMagic.new.file(path.to_s)
        if type_full =~ /image/
          source = Magick::Image.read(path.to_s).first
          thumb = source.resize_to_fill(240,240)
          clean_name = project_name.gsub(' ', '_')
          FileUtils::mkdir_p "system/#{clean_name}_thumbs"
          thumb.write "system/#{clean_name}_thumbs/#{rel_path.to_s.gsub('/', '-').gsub(' ', '_')}"
        end

        file_descript = CWB::File.get_file_description(path.to_s)
        modified = ::File.mtime(path.to_s).to_datetime.to_s
        starred = 'false'
        tag = 'nil'


        file_params = [project,uri,name,rel_path.to_s,created,size,file_descript,folder,modified,starred,tag]
        CWB::File.create(file_params)
      end
    end

    CWB::Project.create(project_params)

    if email
      UserMailer.delay.init_completion_email(email, success=true, project_name)
    end
  rescue => e
    logger.debug e.inspect
    CWB::Project.delete(project.to_s)
    if email
      UserMailer.delay.init_completion_email(email, success=false, project_name)
    end
  end
end