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
          graph << ntriple
        end
      end,
      graph: uri_id
    )

    render json: {
      id: @uri.to_s,
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

  # def update

  #   CWB.sparql(:update).insert_data(
  #   update(<<-EOS)
  #     WITH <#{graph_uri}>
  #     DELETE {
  #       <#{graph_uri}> dcterms:title ?name .
  #       <#{graph_uri}> dcterms:description ?description .
  #     }
  #     INSERT {
  #       <#{graph_uri}> dcterms:title "#{params[:name]}" .
  #       <#{graph_uri}> dcterms:description "#{params[:description]}" .
  #     }
  #     WHERE {
  #       <#{graph_uri}> dcterms:title ?name .
  #       <#{graph_uri}> dcterms:description ?description .
  #     }
  #   EOS

  #   render json: {
  #     id: graph_uri,
  #     name: params[:name],
  #     description: params[:description],
  #     path: params[:path],
  #   }
  # end

  def destroy
    CWB.sparql(:update).delete
  end

end
