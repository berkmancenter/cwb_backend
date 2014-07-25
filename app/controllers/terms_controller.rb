class TermsController < ApplicationController
  def index
    render json: CWB::Term.each(params[:project_id])
  end

  def show
    if !(resource = CWB::Term.find(params[:id], params[:project_id]))
      render json: {}, status: 404
    else
      render json: resource
    end
  end
end
