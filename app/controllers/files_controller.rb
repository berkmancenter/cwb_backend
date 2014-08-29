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

  # def create
  #   scope_uri = params[:id]
  #   uri =  CWB::Resource.unique_uri
  #   project = params[:id]
  #   colocation = file_params[:colocation]
  #   name = file_params[:name]
  #   path = file_params[:path]
  #   created = file_params[:created]
  #   size = file_params[:size]

  #   params_array = 
  #     [
  #       scope_uri, uri, project, colocation,
  #       name, path, created, size
  #     ]

  #   CWB::File.create(params_array)

  #   render json: {
  #     id: uri,
  #     project: params[:id],
  #     colocation: colocation,
  #     name: name,
  #     path: path,
  #     created: created,
  #     size: size
  #   }
  # end

  # def destroy
  #   uri = RDF::URI(params[:id])
  #   # CWB::File.delete(params[:id], params[:project_id])
  #   CWB.sparql(:update).delete_data( [[ uri, RDF.type, PIM.File]])
  #   render json: { id: params[:id] }
  # end


  private

  def file_params
    params.require(:file)
      .permit(:colocation, :name, :path, :created, :size) 
  end
end
