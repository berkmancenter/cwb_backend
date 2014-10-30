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
    logger.info "starting project creation job"
    uri = RDF::URI(CWB::BASE_URI.to_s + name)

    project_params = [uri, name, descript, path]
    project_dir = project_params[3]
    project = project_params[0]
    project_name = project.to_s.sub(CWB::BASE_URI.to_s, '')

    logger.info "building vocabularies from fixtures"
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

    logger.info "building terms from fixtures"
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

    logger.info "building project"
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
        logger.info "creating folder"
        logger.info "#{folder_params}"
        CWB::Folder.create(folder_params)
      elsif ::File.ftype(path) == 'file'
        logger.info "creating file"
        logger.info "#{[project, uri, name, path, rel_path, project_name]}"
        CWB::File.file_creation(project, uri, name, path, rel_path, project_name)
      end

    end

    logger.info "creating project"
    CWB::Project.create(project_params)

    if email
      logger.info "sending success notification"
      UserMailer.delay.init_completion_email(email, success=true, project_name)
    end
  rescue => e
    logger.info "error rescued!"
    logger.info e.message
    logger.info e.backtrace.join("\n")

    logger.info "deleting project"
    CWB::Project.delete(project.to_s)
    if email
      logger.info "sending failure notification"
      UserMailer.delay.init_completion_email(email, success=false, project_name)
    end
  end

  def self.scrub_path_to_png(path)
    path.to_s.gsub('/', '-').gsub(' ', '_').gsub(/(\.jpg|\.jpeg|\.png|\.gif|\.tif|\.pdf)$/i, '.png')
  end
end
