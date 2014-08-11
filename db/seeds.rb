puts 'creating five accounts'
5.times { Fabricate(:account) }
puts 'Creating account with know credentials...'
puts "  name: 'mb' with password: 'mb'"
known_account = CWB::Account.new(name: 'mb', email: 'mb@test.com', password: 'mb')
known_account.save
