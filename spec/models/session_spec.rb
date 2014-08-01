describe CWB::Session do
  let(:account) { FactoryGirl.create(:account) }

  it 'returns nil with bad auth credentials' do
    password = account.password[0..-3]
    expect(CWB::Session.authenticate(account.name, password)).to be_nil
  end
end
