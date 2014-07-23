class CWB::File < CWB::Node

  PATTERN = [
    [:resource, RDF.type, PIM.File],
    [:resource, PIM.project, :project],
    [:resource, PIM.colocation, :folder],
    [:resource, RDF::DC.title, :name],
    [:resource, RDF::DC.source, :path],
    [:resource, RDF::DC.created, :created],
    [:resource, RDF::DC.extent, :size],
  ].freeze

  def to_hash
    super.merge({
      project: @project.to_s,
      folder: @folder.to_s,
      name: @name.to_s,
      size: @size.to_s.to_i,
      type: 'application/octet-stream', # FIXME
      created: nil,                     # FIXME
      modified: nil,                    # FIXME
    })
  end
end
