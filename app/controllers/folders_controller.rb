class FoldersController < ApplicationController
  ##
  # GET /projects/:project_id/folders
  def index
    render :json => CWB::Folder.each(params[:project_id])
  end

  ##
  # POST /projects/:project_id/folders
  def create
    forbidden # this operation not permitted via HTTP
  end

  ##
  # GET /projects/:project_id/folders/:id
  def show
    if !(resource = CWB::Folder.find(params[:id], params[:project_id]))
      render :json => {}, :status => 404
    else
      render :json => resource
    end
  end

  ##
  # PUT /projects/:project_id/folders/:id
  def update
    todo # TODO
  end

  ##
  # DELETE /projects/:project_id/folders/:id
  def destroy
    forbidden # this operation not permitted via HTTP
  end
end
