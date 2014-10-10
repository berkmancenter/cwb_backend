require 'rubygems'
require 'zip'
require 'find'
require 'fileutils'

module CWB
  class Project < CWB::Resource
    attr_accessor :name, :description, :path
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

    def self.zip_derivative(dir, remove_after = false)
      zip_dir = Rails.root.join('derivatives', 'derivatives.zip').to_s
      Zip::ZipFile.open(zip_dir, Zip::ZipFile::CREATE)do |zipfile|
        Find.find(dir) do |path|
          Find.prune if File.basename(path)[0] == ?.
          dest = /#{dir}\/(\w.*)/.match(path)
          # Skip files if they exists
          begin
            zipfile.add(dest[1],path) if dest
          rescue Zip::ZipEntryExistsError
          end
        end
      end
      FileUtils.rm_rf(dir) if remove_after
    end
  end
end
