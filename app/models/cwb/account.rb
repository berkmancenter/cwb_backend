class CWB::Account < CWB::Resource
  PATTERN = [
    [:resource, RDF.type, RDF::FOAF.OnlineAccount],
    [:resource, RDF::FOAF.nick, :nick],
    #[:resource, RDF::FOAF.name, :name], # TODO
    [:resource, RDF::FOAF.mbox, :email],
    [:resource, PIM.password, :password], # SHA-1 of password
  ].freeze

  def self.query(graph = nil, options = {})
    super(graph, {:distinct => true}.merge(options)).order_by(:nick)
  end

  # @see app/fixtures/account_fixtures.js
  def to_hash
    super.merge({
      nick: @nick.to_s,
      #name: @name.to_s, # TODO
      email: @email.to_s,
      password: @password.to_s,
      isAdmin: false,
    })
  end
end
