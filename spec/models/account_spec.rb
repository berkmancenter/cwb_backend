describe CWB::Account do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:account)).to be_valid
  end
  it 'is invalid without name' do
    expect(FactoryGirl.build(:account, name: nil)).to_not be_valid
  end
  it 'is invalid without email' do
    expect(FactoryGirl.build(:account, email: nil)).to_not be_valid
  end
  it 'is invalid without password' do
    expect(FactoryGirl.build(:account, password: nil)).to_not be_valid
  end

  it 'encrypts the password before save' do
    account = FactoryGirl.create(:account)
    expect(BCrypt::Password.new(account.password_hash)).to eq(account.password)
  end
end
