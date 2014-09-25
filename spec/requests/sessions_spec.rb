describe 'With correct authentication credentials' do
  let(:account) { FactoryGirl.create(:account) }
  let(:old) { account.token }
  before(:each) do
    sign_in(account)
  end

  context 'signing in' do
    it 'will set session[:token]' do
      expect(session[:token]).to eq(account.token)
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
      expect(CWB::Account.find(account).token).to_not eq(old)
    end
  end
end
