class FilesController < ApplicationController
  before_action :set_current_user
  before_action :authed?
  respond_to :json

  def index
    render json: CWB::File.each(params[:project_id])
  end

  def show
    if !(resource = CWB::File.find(params[:id], params[:project_id]))
      render json: {}, status: 404
    else
      render json: resource
    end
  end
end
