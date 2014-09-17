puts 'creating five accounts'
5.times { Fabricate(:account) }
puts 'Creating user account with credentials:'
puts "username: 'mb' with password: 'mb'"
known_account = CWB::Account.new(username: 'mb', password: 'mb')
known_account.save
puts 'Creating admin account with credentials:'
puts 'username: admin with password: admin'
admin_account = CWB::Account.new(username: 'admin', password: 'admin', account_manager: true)
admin_account.save

puts "assoc'ing profiles to accounts"
CWB::Account.all.each_with_index do |a,i|
  profile = a.build_profile(name: "profile_name_#{i}", email: "profile_email_#{i}@email.com")
  profile.save
  a.profile_id = profile.id
  a.save
end
