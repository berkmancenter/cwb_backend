describe 'With correct authentication credentials' do
  before(:each) do
    @account =  FactoryGirl.create(:account)
    post '/sessions',
      session: { username: @account.name, password: @account.password }
  end

  context 'signing in' do
    it 'will set session[:token]' do
      expect(response).to be_success
      expect(session[:token]).to eq(@account.token)
    end
  end

  context 'signing out' do
    it 'will clear out session token and redirect' do
      get '/logout'
      expect(session[:token]).to be_nil
      expect(response).to have_http_status(:redirect)
    end

    it 'will change the account.token' do
      get '/logout'
      new = CWB::Account.find(@account).token
      expect(new).to_not eq(@account.token)
    end
  end
end
