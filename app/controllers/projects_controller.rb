class ProjectsController < ApplicationController
  # before_action :set_current_user
  # before_action :authed?
  respond_to :json

  def index
    render json: CWB::Project.all
  end

  def show
    render json: CWB::Project.find(params[:id])
  end

  def create
    uri = CWB::Resource.unique_uri
    name = project_params[:name]
    descript = project_params[:description]
    path = project_params[:path] 
    params_array = [uri, name, descript, path]

    CWB::Project.create(params_array)

    render json: {
      id: uri,
      name: project_params[:name],
      description: project_params[:description],
      path: project_params[:path]
    }
  end

  private

  def project_params
    params.require(:project).permit(:name, :description, :path)
  end
end
