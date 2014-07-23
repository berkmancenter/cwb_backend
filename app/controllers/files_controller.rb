class FilesController < ApplicationController
  ##
  # GET /projects/:project_id/files
  def index
    render :json => CWB::File.each
  end

  ##
  # POST /projects/:project_id/files
  def create
    forbidden # this operation not permitted via HTTP
  end

  ##
  # GET /projects/:project_id/files/:id
  def show
    if !(resource = CWB::File.find(params[:id], params[:project_id]))
      render :json => {}, :status => 404
    else
      render :json => resource
    end
  end

  ##
  # PUT /projects/:project_id/files/:id
  def update
    todo # TODO
  end

  ##
  # DELETE /projects/:project_id/files/:id
  def destroy
    forbidden # this operation not permitted via HTTP
  end
end
