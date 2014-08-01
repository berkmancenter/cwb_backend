describe 'With correct authentication credentials' do
  before(:all) do
    @account =  FactoryGirl.create(:account)
  end

  context 'signing in' do
    it 'will return a json token' do

      post '/sign_in',
        session: { name: @account.name, password: @account.password }

      expect(response).to be_success
      expect(json['token']).to eq(@account.token)
    end
  end

  context 'signing out' do
    it 'will redirect' do
      get '/sign_out', nil,
        HTTP_AUTHORIZATION: \
        ActionController::HttpAuthentication::Token
        .encode_credentials(@account.token)

      expect(response).to have_http_status(:redirect)
    end

    it 'will update with a new token' do
      @old = @account.token
      get '/sign_out', nil,
        HTTP_AUTHORIZATION: \
        ActionController::HttpAuthentication::Token
        .encode_credentials(@account.token)

      expect(@new).to_not eq(@old)
    end
  end
end
