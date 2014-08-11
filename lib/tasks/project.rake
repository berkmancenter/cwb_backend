require 'cwb'
require 'date' # for DateTime
require 'find' # for Find.find
require 'pry'

namespace :project do
  desc "List projects in the database."
  task :list => :environment do
    pattern = [
      [:account, RDF.type, PIM.Project],
      [:account, RDF::DC.title, :title],
    ]
    query = CWB.sparql.select.graph(:graph).where(*pattern).order_by(:title)
    query.each_solution.each do |account|
      puts [account.title.to_s, account.account.to_s].join("\t")
    end
  end

  desc "Create a project (options: NAME=my_project, TITLE=\"My Project\", DIR=/path/to/project/files)."
  task :create => :environment do
    project_name, project_title, project_dir = ENV['NAME'], ENV['TITLE'], ENV['DIR']

    if project_name.blank?
      print "Project Name: "
      project_name = $stdin.readline.chomp
    end

    if project_title.blank?
      print "Project Title: "
      project_title = $stdin.readline.chomp
    end

    if project_dir.blank?
      print "Project Path: "
      project_dir = $stdin.readline.chomp
    end

    # Normalize the given project directory path:
    project_dir = project_dir.strip
    project_dir.chomp!('/')
    project_dir = Pathname(project_dir)
    unless Dir.exist?(project_dir)
      abort "ERROR: The project directory '#{project_dir}' does not exist, aborting."
    end

    project_uri = CWB::BASE_URI.join(project_name)
    project_graph = RDF::Graph.new do |graph|
      graph << [project_uri, RDF.type, PIM.Project]
      graph << [project_uri, RDF::DC.title, project_title || project_name]
      graph << [project_uri, RDF::DC.description, '']
      graph << [project_uri, PIM.path, project_dir]
    end
    basic_graph = project_graph.dup

    dir_count = file_count = 0

    parent_resource = nil
    binding.pry
    Find.find(project_dir) do |path|
      next if path.eql?(project_dir)

      path = Pathname(path)
      rel_path = Pathname(path.to_s[(project_dir.to_s.size+1)..-1])
      is_toplevel = rel_path.parent.to_s.eql?('.')

      puts "Processing: #{rel_path}"
      next if is_toplevel && !path.directory? # we don't support files in the root directory
      next if rel_path.basename.to_s == '.DS_Store' # ignore Mac OS X artifacts
      next if rel_path.basename.to_s == 'Thumbs.db' # ignore Windows artifacts

      resource = RDF::URI('file:///' + rel_path.to_s)
      parent_resource = is_toplevel ? nil : RDF::URI('file:///' + rel_path.parent.to_s)

      case path_type = path.ftype.to_sym
        when :directory
          dir_count += 1
          project_graph << [resource, RDF.type, PIM.Directory]
          project_graph << [resource, RDF::DC.title, rel_path.basename.to_s]
          project_graph << [resource, RDF::DC.source, rel_path.to_s]
          project_graph << [resource, RDF::DC.isPartOf, parent_resource] unless parent_resource.nil?
          project_graph << [resource, PIM.colocation, parent_resource] unless parent_resource.nil?
          project_graph << [resource, PIM.project, project_uri]
        when :file
          file_count += 1
          project_graph << [resource, RDF.type, PIM.File]
          project_graph << [resource, RDF::DC.title, rel_path.basename.to_s]
          project_graph << [resource, RDF::DC.source, rel_path.to_s]
          project_graph << [resource, RDF::DC.isPartOf, parent_resource]
          project_graph << [resource, PIM.colocation, parent_resource]
          project_graph << [resource, RDF::DC.created, path.mtime.to_datetime]
          project_graph << [resource, RDF::DC.extent, path.size]
          #project_graph << [resource, RDF::DC.format, ?]
          project_graph << [resource, PIM.extension, path.extname[1..-1]] unless path.extname.empty?
          project_graph << [resource, PIM.project, project_uri]
        else
          warn "Skipped: #{rel_path} (type #{path_type})"
      end
    end

    puts "Processed #{dir_count} directories and #{file_count} files."

    puts "Writing copy of PIM file to ./#{project_name}.nt..."
    RDF::Writer.open("#{project_name}.nt") do |writer|
      project_graph.each_statement do |statement|
        # TODO: RDF.rb 1.0.8 will support this as an RDF::Writer option directly.
        statement.subject.canonicalize! rescue nil
        statement.predicate.canonicalize! rescue nil
        statement.object.canonicalize! rescue nil
        writer << statement
      end
    end

    puts "Creating the project..."
    CWB.sparql(:update).insert_data(basic_graph, :graph => project_uri)
    puts "Created the project '#{project_name}'."
  end

  desc "Remove a project (options: NAME=my_project)."
  task :remove => :environment do
    project_name = ENV['NAME']

    if project_name.blank?
      print "Project Name: "
      project_name = $stdin.readline.chomp
    end

    project_uri = CWB::BASE_URI.join(project_name)
    CWB.sparql(:update).clear_graph(project_uri)
    puts "Removed the project '#{project_name}'."
  end
end

