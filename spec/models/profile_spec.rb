describe CWB::Profile do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:profile)).to be_valid
  end
end
