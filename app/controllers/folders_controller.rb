class FoldersController < ApplicationController
  before_action :set_current_user
  before_action :authed?
  respond_to :json

  def index
    folders = CWB::Folder.nested_all(params[:project_id])
    folders.each do |folder|
      folder[:starred_count] = 0
    end
    folders.each do |folder|
      count = 0
      files = CWB::Folder.assoced_files(params[:project_id], folder[:id])
      files.each do |k, v|
        count += 1 if v == true.to_s
        folder[:starred_count] = count
      end
      folder[:project] = params[:project_id]
      folder.each do |k,v|
        folder[k] = nil if v == '_null'
      end
    end
    render json: folders
  end

  def show
    query = CWB::Folder.nested_find(params[:id], params[:project_id])
    resource =
      if query.nil?
        { error: 'Query failed', status: :not_found }
      else
        query
      end

    render json: resource
  end
end
