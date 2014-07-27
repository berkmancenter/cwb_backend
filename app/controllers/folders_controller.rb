class FoldersController < ApplicationController
  def index
    render json: CWB::Folder.each(params[:project_id])
  end

  def show
    if !(resource = CWB::Folder.find(params[:id], params[:project_id]))
      render json: {}, status: 404
    else
      render json: resource
    end
  end

  def update
    todo # TODO
  end
end
