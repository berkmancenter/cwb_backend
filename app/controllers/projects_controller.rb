class ProjectsController < ApplicationController
  ##
  # GET /projects
  def index
    render :json => CWB::Project.each
  end

  ##
  # POST /projects
  def create
    graph_uuid = generate_uuid.to_s
    graph_uri  = CWB::BASE_URI.join(graph_uuid)

    sparql(:update).insert_data(RDF::Graph.new { |graph|
      graph << [graph_uri, RDF.type, PIM.Project]
      graph << [graph_uri, RDF::DC.title, params[:name]]
      graph << [graph_uri, RDF::DC.description, params[:description] || '']
      graph << [graph_uri, PIM.path, params[:path] || '']
    }, :graph => graph_uri)

    render :json => {
      id: graph_uri.to_s,
      name: params[:name],
      description: params[:description] || '',
      path: params[:path] || '',
    }
  end

  ##
  # GET /projects/:id
  def show
    project_id = params[:project_id]

    if !(resource = CWB::Project.find(project_id))
      render :json => {}, :status => 404
    else
      render :json => resource
    end
  end

  ##
  # PUT /projects/:id
  def update
    graph_uri = params[:id]

    update(<<-EOS)
      WITH <#{graph_uri}>
      DELETE {
        <#{graph_uri}> dcterms:title ?name .
        <#{graph_uri}> dcterms:description ?description .
      }
      INSERT {
        <#{graph_uri}> dcterms:title "#{params[:name]}" .
        <#{graph_uri}> dcterms:description "#{params[:description]}" .
      }
      WHERE {
        <#{graph_uri}> dcterms:title ?name .
        <#{graph_uri}> dcterms:description ?description .
      }
    EOS

    render :json => {
      id: graph_uri,
      name: params[:name],
      description: params[:description],
      path: params[:path],
    }
  end

  ##
  # DELETE /projects/:id
  def destroy
    CWB::Project.destroy!(params[:id])

    render :json => {}
  end
end
