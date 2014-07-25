class ProjectsController < ApplicationController
  def index
    render json: CWB::Project.each
  end

  def show
    if !(resource = CWB::Project.find(params[:project_id]))
      render json: {}, status: 404
    else
      render json: resource
    end
  end
end
