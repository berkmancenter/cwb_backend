Fabrication.configure do |config|
  config.fabricator_path = 'spec/fabricators/**/*fabricator.rb'
  config.path_prefix = Rails.root
  config.sequence_start = 10_000
end
