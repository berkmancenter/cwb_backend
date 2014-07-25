class VocabulariesController < ApplicationController
  def show
    render json: CWB::Vocabulary.each(params[:project_id])
  end

  # def show
  #   if !(resource = CWB::Vocabulary.find(params[:id], params[:project_id]))
  #     render :json => {}, :status => 404
  #   else
  #     render :json => resource
  #   end
  # end
end
