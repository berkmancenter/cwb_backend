class FilesController < ApplicationController
  # before_action :set_current_user
  # before_action :authed?
  respond_to :json

  def index
   files = CWB::File.nested_all(params[:project_id], vocab_uri=nil, tagged=true)
   
    files.each do |file|
      file.each do |k,v|
        file[k] = v.to_i if k == :size
      end
    end

   render json:  files
  end

  def show
    query = CWB::File.nested_find(params[:id], params[:project_id], tagged=true)
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

  def tag_file
    file_params[:tags].each {|tag|
      CWB::File.tag_file(params[:project_id], params[:file_id], tag)
    }

    render json: { success: 'Successfully starred files' }
  end

  def untag_file
    file_params[:tags].each {|tag|
      CWB::File.untag_file(params[:project_id], params[:file_id], tag)
    }

    render json: { success: 'Successfully starred files' }
  end
  private

  def file_params
    params.require(:file).permit(ids: [], tags: [])
  end
end
