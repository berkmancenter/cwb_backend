class ProjectsController < ApplicationController
  def index
    render json: CWB::Project.each
  end

  def create
    uri_id = CWB::Project.uri_id

    CWB.sparql(:update).insert_data(
      RDF::Graph.new do |graph|
        # pattern contains each predicate and object
        CWB::Project.pattern.each do |ntriple|
          # pops first ele (:resource) off pattern
          ntriple.shift
          ntriple.unshift(uri_id)
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

  def update
    uri_id = RDF::URI(params[:id])
    data = [[uri_id, RDF.type, PIM.Project]]
    CWB.sparql(:update).delete_data(data)

    uri_id = RDF::URI(uri_id)

    CWB.sparql(:update).insert_data(
      RDF::Graph.new do |graph|
        # pattern contains each predicate and object
        CWB::Project.pattern.each do |ntriple|
          # pops first ele (:resource) off pattern
          ntriple.shift
          ntriple.unshift(uri_id)
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

  def destroy
    uri_id = RDF::URI(params[:id])
    data = [[uri_id, RDF.type, PIM.Project]]
    CWB.sparql(:update).delete_data(data)
  end

end
