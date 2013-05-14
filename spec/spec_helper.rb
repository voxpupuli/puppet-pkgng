dir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(dir, 'lib')

#require 'rspec-puppet'
require 'puppet'
require 'test/unit'
require 'mocha/setup'
require 'helpers'

gem 'rspec'

RSpec.configure do |c|
  c.mock_framework = :mocha
  c.include Helpers
end
