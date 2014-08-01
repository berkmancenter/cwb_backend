describe 'With correct authentication credentials' do
  let(:account) { FactoryGirl.create(:account) }

  context 'signing in' do
    it 'will return a json token' do

      post '/sign_in',
        session: { name: account.name, password: account.password }

      expect(response).to be_success
      expect(json['token']).to eq(account.token)
    end
  end

  context 'signing out' do
    it 'will redirect' do

      get '/sign_out', nil,
        HTTP_AUTHORIZATION: \
        ActionController::HttpAuthentication::Token
        .encode_credentials(account.token)

      expect(response).to have_http_status(:redirect)
    end

    it 'will update with a new token' do

      get '/sign_out', nil,
        HTTP_AUTHORIZATION: \
        ActionController::HttpAuthentication::Token
        .encode_credentials(account.token)

      new_token = CWB::Account.find_by_name(account.name).token
      expect(account.token).to_not eq(new_token)
    end
  end
end
