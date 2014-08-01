describe 'Requesting accounts index' do
  context 'with auth token' do
    let(:account) { FactoryGirl.create(:account) }

    it 'will show a list of all accounts' do

      get '/accounts', nil,
            HTTP_AUTHORIZATION: \
            ActionController::HttpAuthentication::Token
            .encode_credentials(account.token)

      expect(response).to have_http_status(:success)
      expect(json.length).to eq(1)
    end
  end

  context 'with no auth token' do
    it 'will not show any accounts' do
      get '/accounts'
      expect(response).to have_http_status(:unauthorized)
      expect(@request.env['HTTP_ACCEPT']).to_not match(/json/)
    end
  end
end
