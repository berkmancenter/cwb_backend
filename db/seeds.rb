puts 'Creating mb account with credentials:'
puts "username: 'mb' with password: 'mb'"
mb_account = CWB::Account.new(username: 'mb', password: 'mb', account_manager: true)
mb_account.save
mb_profile = mb_account.build_profile(name: "Ryan Clardy", email: "ryan@metabahn.com")
mb_profile.save
mb_account.profile_id = mb_profile.id
mb_account.save

puts 'Creating cwb account with credentials:'
puts 'username: cwb with password: cwb'
cwb_account = CWB::Account.new(username: 'cwb', password: 'cwb')
cwb_account.save
cwb_profile = cwb_account.build_profile(name: "Jennifer Jubinville", email: "jjubinville@cyber.law.harvard.edu")
cwb_profile.save
cwb_account.profile_id = cwb_profile.id
cwb_account.save

puts 'Creating cwb_admin account with credentials:'
puts 'username: cwb_admin with password: cwb_admin'
admin_account = CWB::Account.new(username: 'cwb_admin', password: 'cwb_admin', account_manager: true)
admin_account.save
admin_profile = admin_account.build_profile(name: "Jennifer Jubinville", email: "jjubinville@cyber.law.harvard.edu")
admin_profile.save
admin_account.profile_id = admin_profile.id
admin_account.save
