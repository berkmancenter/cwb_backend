class FilesController < ApplicationController
  before_filter :authed?

  def index
    render json: CWB::File.each
  end

  def show
    if !(resource = CWB::File.find(params[:id], params[:project_id]))
      render json: {}, status: 404
    else
      render json: resource
    end
  end
end
