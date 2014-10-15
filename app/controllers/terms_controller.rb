class TermsController < ApplicationController
  before_action :set_current_user
  before_action :authed?
  respond_to :json

  def index
    proj_id = params[:project_id]
    terms = CWB::Term.nested_all(proj_id, params[:vocabulary_id])
    terms.each do |t|
      files_query = CWB.sparql.select.graph(proj_id).where([:uri, PIM.tagged, RDF::URI(t[:id])])
      count = files_query.execute.count
      t[:tagged_count] = count
    end
    render json: terms
  end

  def show
    if resource = CWB::Term.nested_find(params[:id], params[:project_id])
      files_query = CWB.sparql.select.graph(params[:project_id]).where([:uri, PIM.tagged, RDF::URI(params[:id])])
      count = files_query.execute.count
      resource[:tagged_count] = count
      render json: resource
    else
      render json: {}, status: 404
    end
  end

  def create
    label = term_params[:label].gsub(' ', '__')
    uri = RDF::URI('http://facade.mit.edu/dataset/' + label + UUIDTools::UUID.timestamp_create)
    project = RDF::URI(params[:project_id])
    vocab = RDF::URI(params[:vocabulary_id])
    desc = term_params[:description]
    locked = 'false'

    params = [project, uri, label, vocab, desc, locked]

    if !(resource = CWB::Term.turtle_create(params))
    #def self.graph_pattern(_project=nil,uri=nil,label=nil,vocab=nil,description=nil)
      render json: {}, status: 404
    else
      render json: resource
    end
  end

  def update
    resource = CWB::Term.nested_find(params[:id], params[:project_id])

    unless resource.empty?

      old_uri = RDF::URI(params[:id])
      project_uri = RDF::URI( params[:project_id] )
      vocab = RDF::URI(params[:vocabulary_id])
      label = resource[:label].gsub(' ', '__')
      desc = resource[:description]
      locked = resource[:locked]

      files = CWB::Term.file_tag_delete(project_uri, old_uri)

      del_params = [project_uri,old_uri,label,vocab,desc,locked]
      CWB::Term.term_delete(del_params)
      
      label = term_params[:label].gsub(' ', '__')
      new_uri = RDF::URI('http://facade.mit.edu/dataset/' + label + UUIDTools::UUID.timestamp_create)
      project_uri = RDF::URI(params[:project_id])
      vocab = RDF::URI(params[:vocabulary_id])
      desc = term_params[:description]
      locked = 'false'

      CWB::Term.file_tag_create(project_uri, new_uri, files)

      create_params = [project_uri, new_uri, label, vocab, desc, locked]
      CWB::Term.turtle_create(create_params)

      response = {
        id: new_uri.to_s,
        vocabulary_id: vocab.to_s,
        label: label,
        description: desc,
        locked: locked
      }

      render json: response
    else
      render json: {}, status: 404
    end
  end

  def destroy
    resource = CWB::Term.nested_find(params[:id], params[:project_id])

    uri = RDF::URI(params[:id])
    project_uri = params[:project_id]
    vocab = RDF::URI(params[:vocabulary_id])
    label = resource[:label].gsub(' ', '__')
    desc = resource[:description]
    locked = resource[:locked]

    del_params = [project_uri,uri,label,vocab,desc,locked]

    if resource = CWB::Term.file_tag_delete(project_uri, uri) && CWB::Term.term_delete(del_params)
      render json: resource
    else
      render json: {}, status: 404
    end
  end

  private

  def term_params
    params.require(:term).permit(:label, :description)
  end
end
