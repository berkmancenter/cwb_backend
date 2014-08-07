class VocabulariesController < ApplicationController
  before_filter :authed?

  def index
    render json: CWB::Vocabulary.each(params[:vocabulary_id])
  end
end
