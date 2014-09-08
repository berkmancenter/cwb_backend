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
end
