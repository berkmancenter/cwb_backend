class VocabulariesController < ApplicationController
  before_action :set_current_user
  before_action :authed?
  respond_to :json

  def index
    render json: CWB::Vocabulary.nested_all(params[:project_id])
  end

  def show
    render json: RDF::Vocabulary('http://libraries.mit.edu/ontologies/pim/pim1.0#')
  end
end
