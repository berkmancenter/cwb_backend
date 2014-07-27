class FoldersController < ApplicationController
  def index
    render json: CWB::Folder.each(params[:project_id])
  end

  def create
    @uri = CWB::Project.graph_uri

    sparql(:update).insert_data(
      RDF::Graph.new do |graph|
        graph << [graph_uri, RDF.type, PIM.Project]
        graph << [graph_uri, RDF::DC.title, params[:name]]
        graph << [graph_uri, RDF::DC.description, params[:description] || '']
        graph << [graph_uri, PIM.path, params[:path] || '']
      end,
      graph: graph_uri
    )

    render json: {
      id: @uri.to_s, name: params[:name],
      description: params[:description], path: params[:path]
    }
  end

  def show
    if !(resource = CWB::Folder.find(params[:id], params[:project_id]))
      render json: {}, status: 404
    else
      render json: resource
    end
  end

  def update
    todo # TODO
  end
end
