class ProjectsController < ApplicationController
  def index
    render json: CWB::Project.each
  end

  def create
    uri_uuid = UUIDTools::UUID.timestamp_create.to_s
    uri_id  = CWB::BASE_URI.join(uri_uuid)
    ntriples_object = CWB::Project.uri_id

    CWB.sparql(:update).insert_data(
      RDF::Graph.new do |graph|
        # pattern contains each predicate and object
        CWB::Project.pattern.each do |ntriple|
          # pops first ele (:resource) off pattern
          ntriple.shift
          ntriple.unshift(ntriples_object)
          if ntriple[-1] == :name
            ntriple.pop
            ntriple.push(params[:name]) 
          end
          if ntriple[-1] == :description
            ntriple.pop
            ntriple.push(params[:description]) 
          end
          graph << ntriple
        end
      end
    )

    render json: {
      id: uri_id,
      name: params[:name],
      description: params[:description],
      path: params[:path]
    }
  end

  def show
    if !(resource = CWB::Project.find(params[:id]))
      render json: {}, status: 404
    else
      render json: resource
    end
  end

  def destroy
    CWB.sparql(:update).delete_data(params[:id])
  end

end
