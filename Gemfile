source 'https://rubygems.org'

ruby File.read(File.dirname(__FILE__) + '/.ruby-version').strip

gem 'active_model_serializers'
gem 'excon'
gem 'pg'
gem 'pry-rails'
gem 'puma', '~> 3.0'
gem 'slim'
gem 'slim-rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'rails_12factor', group: :production
gem 'uglifier'

group :development, :test do
  gem 'byebug', platform: :mri
end

group :test do
  gem 'rspec-rails', '~> 3.5'
  gem 'webmock'
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console'
end
