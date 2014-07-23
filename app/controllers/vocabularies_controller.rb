class VocabulariesController < ApplicationController
  ##
  # GET /vocabularies
  def index
    render :json => CWB::Vocabulary.each(params[:project_id])
  end

  ##
  # POST /vocabularies
  def create
    forbidden # this operation not permitted via HTTP
  end

  ##
  # GET /vocabularies/:id
  # def show
  #   if !(resource = Vocabulary.find(params[:id], params[:project_id]))
  #     render :json => {}, :status => 404
  #   else
  #     render :json => resource
  #   end
  # end

  ##
  # PUT /vocabularies/:id
  def update
    forbidden # this operation not permitted via HTTP
  end

  ##
  # DELETE /vocabularies/:id
  def destroy
    forbidden # this operation not permitted via HTTP
  end
end
