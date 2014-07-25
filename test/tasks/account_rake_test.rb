require 'test_helper'
require 'rake'

describe 'account:list task' do
  before do
    load File.expand_path("#{Rails.root}/lib/tasks/account.rake")
    Rake::Task.define_task(:environment)
  end

  it 'should list all accounts' do
    skip
  end
end
