class FilesController < ApplicationController
  def index
    render json: CWB::File.each
  end

  def create
    ntriples_object = CWB::Project.graph_context_id
    CWB.sparql(:update).insert_data(
      RDF::Graph.new( 
        CWB::Project.pattern.each do |ntriple|
          # pattern contains each predicate and object
          ntriple.unshift(ntriples_object)
        end
      )
    )

    render json: {
      id: @uri.to_s,
      name: params[:name],
      description: params[:description],
      path: params[:path]
    }
  end

  def show
    if !(resource = CWB::File.find(params[:id], params[:project_id]))
      render json: {}, status: 404
    else
      render json: resource
    end
  end

  def update
    todo # TODO
  end
end
