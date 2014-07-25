require 'rake/testtask'

Rake::TestTask.new do |t|    
  t.libs << "test"
  t.test_files = ['test/**/*_test.rb']
end
