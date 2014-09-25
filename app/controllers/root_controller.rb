require 'rdf/rdfxml'

class RootController < ApplicationController
  before_action :set_current_user
  before_action :authed?, only: ['download']

  def index
    build_dir = Rails.root.join('public/static/cwb/en')

    if build_dir.exist?
      current_build = build_dir.entries
        .find { |entry| entry.basename.to_s =~ /^[a-z0-9]{40}$/ }

      filepath = build_dir.join(current_build, 'index.html')
      render text: File.read(filepath)
    else
      render text: "Couldn't find the build."
    end
  end

  def download
    @writer = RDF::Writer.for(:rdfxml).buffer do |write|
      query = CWB.sparql.construct([:s, :p, :o]).graph("#{CWB::BASE_URI + params[:project_id]}").where([:s, :p, :o])
      @stuff = write << query.result
    end

    if params[:choice] == 'rdfxml'

      send_data @writer,
                filename: 'pim.rdf',
                type: 'application/rdf+xml',
                disposition: 'attachment'
      
    elsif params[:choice] == 'n3'
      @writer = RDF::NTriples::Writer.buffer do |writer|
        writer.write_graph(@stuff.graph)
      end

      send_data @writer,
                filename: 'pim.n3',
                type: 'application/n-triples',
                disposition: 'attachment'
    end
  end

  private

  def root_params
    params.require(:root)
      .permit(:choice) 
  end
end
