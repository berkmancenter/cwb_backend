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
    uri = RDF::URI(CWB::BASE_URI.to_s + project_params[:name])
    name = project_params[:name]
    descript = project_params[:description]
    path = project_params[:path] 
    params_array = [uri, name, descript, path]

    result = CWB::Project.project_init(params_array)

    if result[:success]
      status = 200
      response = {
        id: uri.to_s,
        name: project_params[:name],
        description: project_params[:description],
        path: project_params[:path]
      }
    else
      status = 400
      response = {
        error: result[:error]
      }
    end

    render json: response, status: status
  end

  def update
    uri = RDF::URI(params[:id])
    name = project_params[:name]
    descript = project_params[:description]
    path = project_params[:path] 
    params_array = [uri, name, descript, path]

    CWB::Project.update(params_array)

    render json: {
      id: uri,
      name: name,
      description: descript,
      path: path
    }
  end

  def destroy
    CWB::Project.delete(params[:id])
    render json: { id: params[:id] }
  end
    
  private

  def project_params
    params.require(:project).permit(:name, :description, :path)
  end
end
