class VocabulariesController < ApplicationController
  before_filter :authed?

  def index
    render json: RDF::Vocabulary('http://libraries.mit.edu/ontologies/pim/pim1.0#')
  end

  def show
    render json: CWB::Vocabulary.each(params[:vocabulary_id])
  end
end
