puts 'creating five accounts'
5.times { Fabricate(:account) }
puts 'Creating account with know credentials...'
puts "  name: 'dan' with password: 'password'"
known_account = CWB::Account.new(name: 'dan', email: 'dan@test.com', password: 'password')
known_account.save
