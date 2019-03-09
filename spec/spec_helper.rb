require 'pry'
require 'simplecov'

SimpleCov.start do
  add_filter '/spec'
  add_filter '/vendor'
end

require 'cloud_compose'

Dir.glob(File.expand_path('support/**/*.rb', __dir__)).each { |f| require f }

RSpec.configure do |config|
  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
