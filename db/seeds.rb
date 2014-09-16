puts 'creating five accounts'
5.times { Fabricate(:account) }
puts 'Creating account with know credentials...'
puts "username: 'mb' with password: 'mb'"
known_account = CWB::Account.new(username: 'mb', password: 'mb')
known_account.save

puts "assoc'ing profiles to accounts"
CWB::Account.all.each_with_index do |a,i|
  a.build_profile(name: "profile_name_#{i}", email: "profile_email_#{i}@email.com")
  a.save
end
