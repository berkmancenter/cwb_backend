require 'cwb/pim'
require 'sparql/client' # @see https://rubygems.org/gems/sparql-client

module CWB
  BASE_URI = RDF::URI('http://facade.mit.edu/dataset/').freeze

  ##
  # Returns the SPARQL client for the application's database endpoint.
  #
  # @param  [Symbol] `:query` or `:update`
  # @return [SPARQL::Client]
  def self.sparql(mode = :query)
    raise ArgumentError if !mode.eql?(:query) && !mode.eql?(:update)

    # The value of $cwb_database_*_url is set on application bootstrap by
    # the `config/initializers/cwb.rb` initializer, based on the settings in
    # the `config/database.yml` configuration file.
    @sparql ||= {}
    @sparql[mode] ||= SPARQL::Client.new(eval("$cwb_database_#{mode}_url"), {
      # 4store 1.1.5 requires that SPARQL 1.1 Update requests be performed
      # using the legacy POST application/x-www-form-urlencoded mechanism
      # instead of the more straightforward POST application/sparql-update
      # mechanism:
      :protocol => 1.0,
    })
  end
end

require 'cwb/resource'
