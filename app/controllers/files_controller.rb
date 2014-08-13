class FilesController < ApplicationController
  # before_action :set_current_user
  # before_action :authed?
  respond_to :json

  def index
    render json: CWB::File.nested_each(params[:project_id])
  end

  def show
    query = CWB::File.nested_find(params[:id], params[:project_id])
    resource =
      if query.nil?
        { error: 'Query failed', status: :not_found }
      else
        query
      end

    render json: resource
  end
end
