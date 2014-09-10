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
    uri = RDF::URI('http://facade.mit.edu/dataset/' + term_params[:label])
    project = RDF::URI(params[:project_id])
    vocab = RDF::URI(params[:vocabulary_id])
    label = term_params[:label]
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
  end

  def destroy
  end

  private

  def term_params
    params.require(:term).permit(:label, :description)
  end
end
