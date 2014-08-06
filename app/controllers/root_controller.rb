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
    require 'rdf/rdfxml'
    @writer = RDF::Writer.for(:rdfxml).buffer do |write|
      query = CWB.sparql.construct([:s, :p, :o]).where([:s, :p, :o])
      query = query.from(RDF::URI(params[:project_id])) if params[:project_id]
      write << query.result
    end

    send_data @writer,
              filename: 'pim.rdf',
              type: 'application/rdf+xml',
              disposition: 'attachment'
  end
end
