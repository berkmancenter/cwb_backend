describe 'Requesting projects index' do
  after(:all) do
    %x(pkill 4s-backend)
    %x(pkill 4s-httpd)
    %x(4s-backend-setup test)
    %x(4s-backend dan)
    %x(4s-httpd -p 8890 dan)
  end
  context 'with auth token' do
    before { create_project('testname') }

    it 'will show all projects' do
      get '/projects'
      expect(json.count).to eq(1)
    end
  end
end



