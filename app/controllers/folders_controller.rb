class FoldersController < ApplicationController
  before_action :set_current_user
  before_action :authed?
  respond_to :json

  def index
    folders = CWB::Folder.nested_all(params[:project_id])
    folders.each do |folder|
      folder[:project] = params[:project_id]
      folder[:tagged_count] = 0
      folder[:starred_count] = 0
    end
    folders.each do |folder|
      count = 0
      tagged_files=[]

      files = CWB::Folder.assoced_files(params[:project_id], folder[:id])

      files.each do |k, v|
        count += 1 if v == 'true'
        folder[:starred_count] = count
      end

      files = CWB::Folder.assoced_tags(params[:project_id], folder[:id])

      files.each do |i|
        next if i.values.first == 'nil' || tagged_files.include?(i.keys.first)
        tagged_files << i.keys.first
      end

      folder[:tagged_count] = tagged_files.count
      folder[:file_count] = files.uniq { |i| i.keys.first }.count

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
