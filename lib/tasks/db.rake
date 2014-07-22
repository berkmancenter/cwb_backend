require 'cwb'
require 'uri'

namespace :db do
  desc "Configure the SPARQL database endpoint URL (options: ENDPOINT=http://...)."
  task :config do
    query_endpoint  = ENV['QUERY_ENDPOINT']  || ENV['ENDPOINT']
    update_endpoint = ENV['UPDATE_ENDPOINT'] || ENV['ENDPOINT']

    if query_endpoint.blank?
      print "Database Query Endpoint URL: "
      query_endpoint = $stdin.readline.chomp
    end
    query_endpoint_url = ::URI.parse(query_endpoint)

    if update_endpoint.blank?
      print "Database Update Endpoint URL: "
      update_endpoint = $stdin.readline.chomp
    end
    update_endpoint_url = ::URI.parse(update_endpoint)

    unless %w(http https).include?(query_endpoint_url.scheme) &&
           %w(http https).include?(update_endpoint_url.scheme)
      abort "Invalid URL scheme. Only HTTP and HTTPS database endpoint URLs are supported."
    end

    File.open(Rails.root.join('config/database.yml'), 'wb') do |config|
      config << YAML.dump({
        :production => {
          :adapter  => :sparql,
          :query_endpoint  => query_endpoint_url.to_s,
          :update_endpoint => update_endpoint_url.to_s,
        },
        :development => {
          :adapter => :sparql,
          :query_endpoint  => query_endpoint_url.to_s,
          :update_endpoint => update_endpoint_url.to_s,
        },
      })
    end
  end
end

