source 'https://rubygems.org'

gem "redcarpet"
gem "activesupport"
gem "highline"
gem "rake"
gem "coderay"
gem "middleman", '~> 3.0'
gem "byebug"
gem "thin"
gem "rack"
gem "listen"
gem "builder"
gem "middleman-alias"
gem "middleman-swiftype", :git => "git://github.com/LeonB/middleman-swiftype.git"
gem "underscore-rails"

source 'https://rails-assets.org' do
  gem "rails-assets-js-md5"
  gem "rails-assets-moment"
end

group :development, :test do
  gem 'pry'
end

group :test do
  gem "rspec"
  gem "capybara"
  gem "poltergeist"
  gem "hashie"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin]
gem 'wdm', '>= 0.1.0', platforms: [:mingw, :mswin]
