describe 'Requesting accounts index' do
  context 'with auth token' do
    let(:account) { FactoryGirl.create(:account) }

    before(:each) do
      sign_in(account)
    end

    it 'will show a list of all accounts' do
      get '/accounts'
      expect(response).to have_http_status(:success)
      expect(json.length).to eq(1)
    end

    context 'as admin' do
      it 'can create an account' do
       post '/accounts', account: { username: 'test_username', password: 'test_password' } 
       expect(response).to have_http_status(:success)
      end
    end
  end

  context 'when not authed' do
    it 'will not show any accounts' do
      get '/accounts'
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
