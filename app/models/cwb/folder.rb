module CWB
  class Folder < CWB::Resource
    def self.graph_pattern(
                            project=nil,uri=nil,
                            name=nil,path=nil,parent=nil
                          )
      [
        [uri||:uri, RDF.type, PIM.Directory],
        [uri||:uri, PIM.project, project||:project],
        [uri||:uri, RDF::DC.title, name||:name],
        [uri||:uri, RDF::DC.source, path||:path],
        [uri||:uri, PIM.colocation, parent||:parent]
      ]
    end

    def self.assoced_files(project, folder_id)
      project_uri = RDF::URI(project)
      graph_pattern = [
        [:uri, RDF.type, PIM.File],
        [:uri, PIM.colocation, folder_id],
        [:uri, PIM.isStarred, :starred]
      ]

      query = CWB.sparql.select.graph(project_uri).where(*graph_pattern).distinct
      solutions = query.execute
      fstar_array=[]
      _contain=[]
      solutions.each_with_index do |s, index|
        s.bindings.each do |k,v|
          if k == :uri
            @key = v.to_s
          elsif k == :starred
            @value = v.to_s
          end
          if @key && @value
            @_hash = Hash[@key, @value]
          end
        end
        fstar_array << @_hash unless @_hash.nil?
      end
      fstar_array.reduce Hash.new, :merge
    end

    def self.assoced_tags(project, folder_id)
      project_uri = RDF::URI(project)
      graph_pattern = [
        [:uri, RDF.type, PIM.File],
        [:uri, PIM.colocation, folder_id],
        [:uri, PIM.tagged, :tag]
      ]

      query = CWB.sparql.select.graph(project_uri).where(*graph_pattern)
      solutions = query.execute
      ftag_array=[]
      _contain=[]
      file_count_array=[]
      solutions.each_with_index do |s, index|
        file_count_array << s unless file_count_array.include?(s)
        s.bindings.each do |k,v|
          if k == :uri
            @key = v.to_s
          elsif k == :tag
            @value = v.to_s
          end
          if @key && @value
            @_hash = Hash[@key, @value]
          end
        end
        ftag_array << @_hash unless @_hash.nil?
      end
      ftag_array
    end
  end
end
