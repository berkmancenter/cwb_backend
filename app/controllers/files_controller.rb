class FilesController < ApplicationController
  before_action :set_current_user
  before_action :authed?
  respond_to :json

  def index
   files = CWB::File.nested_all(params[:project_id], vocab_uri=nil, tagged=true)

    files.each do |file|
      tag_history = CWB::TaggingHistory.where(file_tagged: file[:id]).last
      if tag_history
        file[:last_modified_by] = CWB::Account.find(tag_history.account_id).username
        file[:last_tag_change] = tag_history.created_at
      else
        file[:last_modified_by] = nil
        file[:last_tag_change] = nil
      end
      file[:project] = params[:project_id]
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
        tag_history = CWB::TaggingHistory.where(file_tagged: 'file:/' + query[:path]).last
        if tag_history
          query[:last_modified_by] = CWB::Account.find(tag_history.account_id).username
          query[:last_tag_change] = tag_history.created_at
        end
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
    history = CWB::TaggingHistory.create(account_id: @current_user.id, file_tagged: file_id)
    query = CWB::File.nested_find(file_id, params[:project_id], tagged=true)
    query[:tag].each {|tag|
      unless tag == 'nil'
        CWB::File.untag_file(params[:project_id], file_id, tag)
      end
    } if !query.empty? && query[:tag]

    tagged = [] 
    file_params[:tags].each {|tag|
      tagged << tag
      unless tag == '[]'
        CWB::File.tag_file(params[:project_id], file_id, tag)
      end
      } if file_params[:tags]
    tagged_string = tagged.join(',')
    history.update_attributes(terms_tagged: tagged_string)
    history.save
   end

    render json: { success: 'Successfully taggedfile' }
  end

  def get_thumb
    query = CWB::File.nested_find(params[:file_id], params[:project_id], tagged=true)
    thumb_name = BackgroundInit.scrub_path_to_png(query[:path].to_s)
    path = "system/#{params[:project_id].sub(CWB::BASE_URI.to_s, '').gsub(' ', '_')}" + '_thumbs/' + thumb_name
    if File.file?(path)
      send_file path
    else
      render json: { error: 'Not found' }, status: 404
    end
  end

  def upload_derivative
    upload_file = params[:upload]
    parent_file = params[:file_id].to_s.gsub('file:/', '')
    project_name = params[:project_id].sub(CWB::BASE_URI.to_s, '')
    clean_name = project_name.gsub(' ', '_')

    FileUtils::mkdir_p "derivatives/#{clean_name}"
    upload_path = "derivatives/#{clean_name}/"
    upload_name = Time.now.strftime("%y-%m-%d_%H-%M_") + upload_file.original_filename
    if CWB::File.upload_file(upload_file.tempfile, upload_path, upload_name)
      path = upload_path + upload_name
      rel_path = ::File.dirname(parent_file).to_s + '/' + upload_name
      project = params[:project_id]
      uri = RDF::URI('file:/' +  rel_path)
      name = upload_file.original_filename
      derivative = parent_file
      CWB::File.file_creation(project, uri, name, path, rel_path, project_name, derivative)

      query = CWB::File.nested_find(uri, project, tagged=true)
      query[:id] = uri.to_s
      render json: { success: 'Derivative successfully uploaded', object: query }, status: 200
    else
      render json: { error: 'Derivative upload failed' }, status: 500 
    end
  end

  private

  def file_params
    params.require(:file).permit(ids: [], tags: [])
  end
end
