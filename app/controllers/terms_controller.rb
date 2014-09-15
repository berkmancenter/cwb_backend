class TermsController < ApplicationController
  before_action :set_current_user
  before_action :authed?
  respond_to :json

  def index
    render json: CWB::Term.nested_all(params[:project_id],params[:vocabulary_id])
  end

  def show
    if !(resource = CWB::Term.nested_find(params[:id], params[:project_id]))
      render json: {}, status: 404
    else
      render json: resource
    end
  end

  def create
    label = term_params[:label].gsub(' ', '__')
    uri = RDF::URI('http://facade.mit.edu/dataset/' + label + UUIDTools::UUID.timestamp_create)
    project = RDF::URI(params[:project_id])
    vocab = RDF::URI(params[:vocabulary_id])
    desc = term_params[:description]


    params = [project, uri, label, vocab, desc]

    if !(resource = CWB::Term.turtle_create(params))
    #def self.graph_pattern(_project=nil,uri=nil,label=nil,vocab=nil,description=nil)
      render json: {}, status: 404
    else
      render json: resource
    end
  end

  def update
    resource = CWB::Term.nested_find(params[:id], params[:project_id])

    uri = RDF::URI(params[:id])
    project = params[:project_id]
    vocab = RDF::URI(params[:vocabulary_id])
    label = resource[:label].gsub(' ', '__')
    desc = resource[:description]
    del_params = [project, uri, label, vocab, desc]
    CWB::Term.term_delete(del_params)
    
    label = term_params[:label].gsub(' ', '__')
    uri = RDF::URI('http://facade.mit.edu/dataset/' + label + UUIDTools::UUID.timestamp_create)
    project = RDF::URI(params[:project_id])
    vocab = RDF::URI(params[:vocabulary_id])
    desc = term_params[:description]

    create_params = [project, uri, label, vocab, desc]

    if !(resource = CWB::Term.turtle_create(create_params))
    #def self.graph_pattern(_project=nil,uri=nil,label=nil,vocab=nil,description=nil)
      render json: {}, status: 404
    else
      render json: resource
    end
  end

  def destroy
    resource = CWB::Term.nested_find(params[:id], params[:project_id])

    uri = RDF::URI(params[:id])
    project = params[:project_id]
    vocab = RDF::URI(params[:vocabulary_id])
    label = resource[:label].gsub(' ', '__')
    desc = resource[:description]

    del_params = [project, uri, label, vocab, desc]

    if !(resource = CWB::Term.term_delete(del_params))
      render json: {}, status: 404
    else
      render json: resource
    end
  end

  private

  def term_params
    params.require(:term).permit(:label, :description)
  end
end
