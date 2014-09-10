module CWB
  class File < CWB::Resource
    def self.graph_pattern(
      _project=nil,uri=nil,name=nil,path=nil,
      created=nil,size=nil,type=nil,folder=nil,modified=nil,starred=nil
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
        [uri||:uri, PIM.isStarred, starred||:starred]
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

    def self.single_create(params)
      graph = '<' + params[0].to_s + '>'
      triples = sparql_format_single(params)
      uri = URI.parse('http://localhost:8890/update/')
      http = Net::HTTP.new(uri.host, uri.port)
      postdata = %Q[update=INSERT+DATA+{+GRAPH+#{ graph }+{+#{ triples }+}+}]
      request = Net::HTTP::Post.new(uri.request_uri)
      request.body = postdata
      response = http.request(request)
    end
  end
end
