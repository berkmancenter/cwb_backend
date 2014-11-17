puts 'Creating mb account with credentials:'
puts "username: 'mb', password: 'mb'"
mb_account = CWB::Account.new(username: 'mb', password: 'mb', account_manager: true)
mb_account.save
mb_profile = mb_account.build_profile(name: "Ryan Clardy", email: "ryan@metabahn.com")
mb_profile.save
mb_account.profile_id = mb_profile.id
mb_account.save

puts 'Creating fwb account with credentials:'
puts 'username: fwb, password: fwb'
fwb_account = CWB::Account.new(username: 'fwb', password: 'fwb')
fwb_account.save
cwb_profile = fwb_account.build_profile(name: "FWB Tester", email: "fwb_tester@cyber.law.harvard.edu")
cwb_profile.save
fwb_account.profile_id = cwb_profile.id
fwb_account.save

puts 'Creating admin account with credentials:'
puts 'username: jjubinville, password: jjubinville'
admin_account1 = CWB::Account.new(username: 'jjubinville', password: 'jjubinville', account_manager: true)
admin_account1.save
admin_profile1 = admin_account1.build_profile(name: "Jennifer Jubinville", email: "jjubinville@cyber.law.harvard.edu")
admin_profile1.save
admin_account1.profile_id = admin_profile1.id
admin_account1.save

puts 'Creating admin account with credentials:'
puts 'username: jsd, password: jsd'
admin_account2 = CWB::Account.new(username: 'jsd', password: 'jsd', account_manager: true)
admin_account2.save
admin_profile2 = admin_account2.build_profile(name: "Sebastian Diaz", email: "jsd@cyber.law.harvard.edu")
admin_profile2.save
admin_account2.profile_id = admin_profile2.id
admin_account2.save
