describe 'Profile requests' do
  context 'with token as regular user' do
    let(:account) { FactoryGirl.create(:account, account_manager: 0) }
    let(:other_profile) { FactoryGirl.create(:profile, name: 'other_name') }
    let(:other_account) { FactoryGirl.create(:account, account_manager: 0, profile: other_profile) }
    before(:each) do
      sign_in(account)
    end

    it 'can view a list of profiles' do
      get '/profiles'
      expect(response).to have_http_status(:success)
    end

    it 'can change own profile details' do
      put "/profiles/#{account.profile.id}", profile: { name: 'profile_name', email: 'profile_email' }
      expect(response).to have_http_status(:success)
      expect(CWB::Account.find(account.id).profile.name).to eq('profile_name')
    end

    it 'cannot change others profile details' do
      put "/profiles/#{other_account.profile.id}", profile: { name: 'profile_name', email: 'profile_email' }
      expect(response).to have_http_status(:unauthorized)
      expect(CWB::Account.find(other_account.id).profile.name).to_not eq('profile_name')
    end
  end

  context 'with token as account manager' do
    let(:account) { FactoryGirl.create(:account, account_manager: 1) }
    let(:other_profile) { FactoryGirl.create(:profile, name: 'other_name') }
    let(:other_account) { FactoryGirl.create(:account, account_manager: 0, profile: other_profile) }
    before(:each) do
      sign_in(account)
    end
    
    it 'can change others profile details' do
      put "/profiles/#{other_account.profile.id}", profile: { name: 'profile_name', email: 'profile_email' }
      expect(response).to have_http_status(:unauthorized)
      expect(CWB::Account.find(other_account.id).profile.name).to_not eq('profile_name')
    end
  end
end

