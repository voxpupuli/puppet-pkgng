dir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(dir, 'lib')

#require 'rspec-puppet'
require 'puppet'
require 'mocha/setup'
gem 'rspec'

require 'helpers'

RSpec.configure do |c|
  c.mock_framework = :mocha
  c.include Helpers
end
