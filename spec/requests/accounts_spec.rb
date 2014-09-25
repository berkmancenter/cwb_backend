describe 'Account requests' do
  context 'with auth token as regular user' do
    let(:account) { FactoryGirl.create(:account, account_manager: 0) }
    before(:each) do
      sign_in(account)
    end

    it 'will show a list of all accounts' do
      get '/accounts'
      expect(response).to have_http_status(:success)
      expect(json.length).to eq(1)
    end

    it 'cannot create an account' do
     post '/accounts', account: { username: 'test_username', password: 'test_password' } 
     expect(response).to have_http_status(:unauthorized)
    end

    it 'can update their profile' do
      put "/profiles/#{account.profile.id}", profile: { name: 'test_name', email: 'test_email' }
      expect(response).to have_http_status(:success)
      expect(CWB::Profile.find(account.profile.id).name).to eq('test_name')
    end
  end

  context 'with token as account_manager' do
    let(:account) { FactoryGirl.create(:account, account_manager: 1) }
    let(:other_profile) { FactoryGirl.create(:profile, name: 'other_name') }
    let(:other_account) { FactoryGirl.create(:account, account_manager: 0, profile: other_profile) }
    before(:each) do
      sign_in(account)
    end

    it 'can create an account' do
     post '/accounts', account: { username: 'test_username', password: 'test_password' } 
     expect(response).to have_http_status(:success)
    end

    it 'can delete other accounts' do
      delete "/accounts/#{other_account.id}"
      expect(response).to have_http_status(:success)
    end
  end

  context 'when not authed' do
    it 'will not show any accounts' do
      get '/accounts'
      expect(response).to have_http_status(:unauthorized)
    end
    it 'cannot create accounts' do
      post '/accounts', account: { username: 'test_username', password: 'test_password' } 
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
