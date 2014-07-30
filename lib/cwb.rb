require 'cwb/pim'
require 'sparql/client' # @see https://rubygems.org/gems/sparql-client

module CWB
  BASE_URI = RDF::URI('http://facade.mit.edu/dataset/').freeze

  # Returns the SPARQL client for the application's database endpoint.
  #
  # @param  [Symbol] `:query` or `:update`
  # @return [SPARQL::Client]

  def self.sparql(mode = :query)
    database = YAML.load_file('config/rdf_database.yml')
    env = Rails.env

    if mode.eql?(:query)
      sparql_endpoint = database[env]['query_endpoint']
    elsif mode.eql?(:update)
      sparql_endpoint = database[env]['update_endpoint']
    else
      raise ArgumentError
    end

    @sparql ||= {}
    @sparql[mode] ||= SPARQL::Client.new(sparql_endpoint, protocol: 1.0)

    # 4store 1.1.5 requires that SPARQL 1.1 Update requests be performed
    # using the legacy POST application/x-www-form-urlencoded mechanism
    # instead of the more straightforward POST application/sparql-update
    # mechanism
  end
end
