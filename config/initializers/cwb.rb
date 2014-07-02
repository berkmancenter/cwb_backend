require 'cwb' # @see lib/cwb.rb

# Some SPARQL 1.1 implementations require a different endpoint URL for
# update queries than for read-only queries. The configuration key
# :update_endpoint is for the former and the key :query_endpoint for the
# latter. In the simple case (e.g. for Dydra) the two are equivalent.

$cwb_database_config     = HashWithIndifferentAccess.new(YAML.load(File.read(Rails.root.join('config/database.yml')))) rescue nil
$cwb_database_query_url  = $cwb_database_config[Rails.env]['query_endpoint'] rescue nil
$cwb_database_update_url = $cwb_database_config[Rails.env]['update_endpoint'] rescue $cwb_database_query_url
