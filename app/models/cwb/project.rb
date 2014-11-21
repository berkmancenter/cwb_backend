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

    def self.zip_derivative(dir, zip_dir, remove_after = false)
      manifest_path = zip_dir + "_manifest.txt"
      Zip::ZipFile.open(zip_dir, Zip::ZipFile::CREATE)do |zipper|
        ::File.open(manifest_path, 'w') do |manifest|
          manifest_header(manifest)
          index = 0
          Find.find(dir) do |path|
            Find.prune if ::File.basename(path)[0] == ?.
            dest = /#{dir.shellescape}\/(\w.*)/.match(path)
            # Skip files if they exists
            begin
              if dest
                add_to_zip(path, dest[1], zipper)
                add_to_manifest(dest[1], index, manifest)
                index += 1
              end
            rescue Zip::ZipEntryExistsError
            end
          end
          manifest_footer(manifest)
        end
        add_to_zip(manifest_path, "0-manifest.txt", zipper)
      end
      FileUtils.rm_rf(dir) if remove_after
    end

    private

    def self.manifest_header(file)
      file.puts "Download manifest"
      separator(file)
    end

    def self.manifest_footer(file)
      separator(file)
      file.puts "End of manifest"
    end

    def self.separator(file)
      file.puts "============================================="
    end

    def self.add_to_zip(filepath, filename, zipper)
      zipper.add(filename, filepath)
    end

    def self.add_to_manifest(filename, index, manifest)
      manifest.puts "File #{index+1}: #{filename}"
      manifest.puts
    end
  end
end
