class FilesController < ApplicationController
  before_action :set_current_user
  before_action :authed?
  respond_to :json

  def index
   files = CWB::File.nested_all(params[:project_id], vocab_uri=nil, tagged=true)

    files.each do |file|
      file[:project] = params[:project_id]
      file.each do |k,v|
        file[k] = v.to_i if k == :size
      end

      file[:term_count] = file[:tag].count

    end

   render json:  files
  end

  def show
    query = CWB::File.nested_find(params[:id], params[:project_id], tagged=true)
    resource =
      if query.nil?
        { error: 'Query failed', status: :not_found }
      else
        query[:term_count] = query[:tag].count
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

  def mark_starred_multiple
    file_params[:ids].each {|id|
      CWB::File.mark_starred(id, params[:project_id])
    }

    render json: { success: 'Successfully starred files' }
  end

  def unmark_starred_multiple
    file_params[:ids].each {|id|
      CWB::File.unmark_starred(id, params[:project_id])
    }

    render json: { success: 'Successfully unstarred files' }
  end

  def tag_files
  file_params[:ids].each do |file_id|
    query = CWB::File.nested_find(file_id, params[:project_id], tagged=true)
    query[:tag].each {|tag|
      unless tag == 'nil'
        CWB::File.untag_file(params[:project_id], file_id, tag)
      end
    } if !query.empty? && query[:tag]

    file_params[:tags].each {|tag|
      unless tag == '[]'
        CWB::File.tag_file(params[:project_id], file_id, tag)
      end
      } if file_params[:tags]
   end

    render json: { success: 'Successfully taggedfile' }
  end

  private

  def file_params
    params.require(:file).permit(ids: [], tags: [])
  end
end
