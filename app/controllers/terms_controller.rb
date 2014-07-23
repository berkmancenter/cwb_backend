class TermsController < ApplicationController
  ##
  # GET /projects/:project_id/terms
  def index
    render :json => CWB::Term.each(params[:project_id])
  end

  ##
  # POST /projects/:project_id/terms
  def create
    forbidden # this operation not permitted via HTTP
  end

  ##
  # GET /projects/:project_id/terms/:id
  def show
    if !(resource = CWB::Term.find(params[:id], params[:project_id]))
      render :json => {}, :status => 404
    else
      render :json => resource
    end
  end

  ##
  # PUT /projects/:project_id/terms/:id
  def update
    todo # TODO
  end

  ##
  # DELETE /projects/:project_id/terms/:id
  def destroy
    forbidden # this operation not permitted via HTTP
  end
end
