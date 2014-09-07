class FilesController < ApplicationController
  # before_action :set_current_user
  # before_action :authed?
  respond_to :json

  def index
   files = CWB::File.nested_all(params[:project_id])
   
    files.each do |file|
      file.each do |k,v|
        file[k] = v.to_i if k == :size
      end
    end

   render json:  files
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

  def mark_starred
    star = CWB::File.mark_starred(params[:id], params[:project_id])
    resource =
      if star.nil?
        { error: 'Failed to mark as important.', status: :not_found }
      else
        star
      end

    render json: resource
  end

  def unmark_starred
    star = CWB::File.unmark_starred(params[:id], params[:project_id])
    resource =
      if star.nil?
        { error: 'Failed to mark as important.', status: :not_found }
      else
        star
      end

    render json: resource
  end
end
