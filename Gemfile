source "https://rubygems.org"

group :test do
  gem "rake"
  gem "puppet", ENV['PUPPET_VERSION'] || '~> 4.4.0'
  gem "rspec-puppet", :git => 'https://github.com/rodjek/rspec-puppet.git'
  gem "puppetlabs_spec_helper"
  gem 'rspec-puppet-facts', '~> 1.5', :require => false
  gem "metadata-json-lint"
end

group :development do
  gem "travis"
  gem "travis-lint"
  gem "puppet-blacksmith"
end

