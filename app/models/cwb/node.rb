class CWB::Node < CWB::Resource
  def self.query(graph = nil, options = {})
    super(graph, options).order_by(:name)
  end
end
