describe 'With correct authentication credentials' do
  before(:each) do
    @account =  FactoryGirl.create(:account)
    post '/sign_in',
      session: { name: @account.name, password: @account.password }
  end

  context 'signing in' do
    it 'will return a json token' do
      expect(response).to be_success
      expect(json['token']).to eq(@account.token)
    end

    it 'will set session[:token]' do
      expect(response).to be_success
      expect(session[:token]).to eq(@account.token)
    end
  end

  context 'signing out' do
    it 'will clear out session and redirect' do
      post '/sign_out'
      expect(session[:token]).to be_empty
      expect(response).to have_http_status(:redirect)
    end

    it 'will change the account.token' do
      post '/sign_out'
      new = CWB::Account.find(@account).token
      expect(new).to_not eq(@account.token)
    end
  end
end
