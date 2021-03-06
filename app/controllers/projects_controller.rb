class ProjectsController < ApplicationController
  before_action :set_current_user
  before_action :authed?
  respond_to :json

  def index
    render json: CWB::Project.all
  end

  def show
    render json: CWB::Project.find(params[:id])
  end

  def create
    name = project_params[:name]
    descript = project_params[:description]
    path = project_params[:path] 
    email = @current_user.email || nil
    params_array = [name, descript, path, email]

    bg = BackgroundInit.new

    if bg.validate!(*params_array)
      BackgroundInit.perform_async(*params_array)
      render json: {}, status: 200
    else
      render json: bg.errors, status: 400
    end
  end

  def update
    uri = RDF::URI(params[:id])
    name = project_params[:name]
    descript = project_params[:description]
    path = project_params[:path] 
    params_array = [uri, name, descript, path]

    CWB::Project.update(params_array)

    render json: {
      id: uri,
      name: name,
      description: descript,
      path: path
    }
  end

  def destroy
    project_name = params[:id].sub(CWB::BASE_URI.to_s, '').gsub(' ', '_')
    FileUtils.rm_rf("system/#{project_name}_thumbs")
    FileUtils.rm_rf("derivatives/#{project_name}")

    CWB::Project.delete(params[:id])
    render json: { id: params[:id] }
  end

  def download
    project = CWB::Project.find(params[:project_id])
    name = project.present? ? "#{project[:name]}-PIM" : 'PIM'

    @writer = RDF::Writer.for(:rdfxml).buffer do |write|
      query = CWB.sparql.construct([:s, :p, :o]).graph("#{params[:project_id]}").where([:s, :p, :o])
      @stuff = write << query.result
    end

    if params[:choice] == 'rdfxml'

      send_data @writer,
                filename: "#{name}.rdf",
                type: 'application/rdf+xml',
                disposition: 'attachment'

    elsif params[:choice] == 'n3'
      @writer = RDF::NTriples::Writer.buffer do |writer|
        writer.write_graph(@stuff.graph)
      end

      send_data @writer,
                filename: "#{name}.n3",
                type: 'application/n-triples',
                disposition: 'attachment'
    end
  end

  def derivatives_download
    project = CWB::Project.find(params[:project_id])
    project_name = Rails.root.join('derivatives', params[:project_id].sub(CWB::BASE_URI.to_s, '')).to_s
    clean_name = project_name.gsub(' ', '_')
    FileUtils::mkdir_p(clean_name) unless File.directory?(clean_name)

    zip_dir = Rails.root.join("derivatives", "derivatives-#{SecureRandom.hex(8)}.zip").to_s
    CWB::Project.zip_derivative(clean_name, zip_dir)
    #send derives to endpoint
    File.open(zip_dir, 'r') do |f|
        send_data f.read, filename: "#{project[:name]}_#{Date.today}_derivatives.zip", type: 'application/zip'
    end
    FileUtils.rm(zip_dir)
    FileUtils.rm("#{zip_dir}_manifest.txt")
  end

  private

  def project_params
    params.require(:project).permit(:name, :description, :path)
  end
end
