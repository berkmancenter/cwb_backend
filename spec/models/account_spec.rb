describe CWB::Account do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:account)).to be_valid
  end
  it 'is invalid without name' do
    expect(FactoryGirl.build(:account, username: nil)).to_not be_valid
  end
  it 'is invalid without password' do
    expect(FactoryGirl.build(:account, password: nil)).to_not be_valid
  end

  it 'encrypts the password before save' do
    account = FactoryGirl.create(:account)
    expect(BCrypt::Password.new(account.password_hash)).to eq(account.password)
  end

  it 'has an assoced profile' do
    account = FactoryGirl.create(:account)
    expect(account.profile).to_not be_nil
  end

  it 'deletes assoced profile on destroy' do
    account = FactoryGirl.create(:account)
    profile = account.profile
    account.destroy
    expect{ CWB::Profile.find(profile) }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
