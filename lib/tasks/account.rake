require 'cwb'
require 'digest/sha1' # for Digest::SHA1.hexdigest

namespace :account do
  desc "seed accounts"
  task :seed => :environment do
    pp 'Creating accounts with known credentials...'
    [
      {
        name: "mb",
        password: "mb",
        email: "ryan@metabahn"
      },
      {
        name: "cwb",
        password: "cwb",
        email: "jjubinville@cyber.law.harvard.edu"
      }
    ].each {|args|
      pp "name: '#{args[:name]}' with password: '#{args[:password]}'"
      account = CWB::Account.new(name: args[:name], email: args[:email], password: args[:password])
      account.save
    }
  end

  desc "List accounts."
  task :list => :environment do
    pattern = [
      [:account, RDF.type, RDF::FOAF.OnlineAccount],
      [:account, RDF::FOAF.nick, :name],
    ]
    query = CWB.sparql.select.graph(:graph).where(*pattern).order_by(:name)
    query.each_solution.each do |account|
      puts [account.name.to_s, account.account.to_s].join("\t")
    end
  end

  desc "Create an account (options: NAME=my_account, PASSWORD=\"secret123\", EMAIL=user@example.org)."
  task :create => :environment do
    account_name, account_password, account_email = ENV['NAME'], ENV['PASSWORD'], ENV['EMAIL']

    if account_name.blank?
      print "Account Name: "
      account_name = $stdin.readline.chomp
    end

    if account_password.blank?
      print "Account Password: "
      account_password = $stdin.readline.chomp
    end

    if account_email.blank?
      print "Account Email: "
      account_email = $stdin.readline.chomp
    end

    account_uri = CWB::BASE_URI.join(account_name)
    account_graph = RDF::Graph.new do |graph|
      graph << [account_uri, RDF.type, RDF::FOAF.OnlineAccount]
      graph << [account_uri, RDF::DC.title, account_name]
      graph << [account_uri, RDF::FOAF.nick, account_name]
      graph << [account_uri, RDF::FOAF.mbox, account_email]
      graph << [account_uri, PIM.password, Digest::SHA1.hexdigest(account_password)]
    end

    puts "Creating the user account..."
    CWB.sparql(:update).insert_data(account_graph, :graph => account_uri)
    puts "Created the user account '#{account_name}'."
  end

  desc "Update an account (options: NAME=my_account, PASSWORD=\"secret123\", EMAIL=user@example.org)."
  task :update => :environment do
    account_name = ENV['NAME']

    if account_name.blank?
      print "Account Name: "
      account_name = $stdin.readline.chomp
    end

    # TODO: implementation.
  end

  desc "Remove an account (options: NAME=my_account)."
  task :remove => :environment do
    account_name = ENV['NAME']

    if account_name.blank?
      print "Account Name: "
      account_name = $stdin.readline.chomp
    end

    account_uri = CWB::BASE_URI.join(account_name)
    CWB.sparql(:update).clear_graph(account_uri)
    puts "Removed the user account '#{account_name}'."
  end
end

