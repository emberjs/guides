source 'https://rubygems.org'

gem 'middleman-spellcheck',:git => "https://github.com/mwils/middleman-spellcheck.git", :branch => 'class'
gem "redcarpet"
gem "activesupport", '~> 4.2.10'
gem "highline"
gem "rake"
gem "coderay", :git => "https://github.com/dgeb/coderay.git", :branch => "handlebars"
gem "middleman", '~> 3.0'
gem "thin"
gem "rack"
gem "listen"
gem "builder"
gem "middleman-alias"
gem "underscore-rails"
gem "html-proofer"
gem "middleman-toc", :git => "https://github.com/ember-learn/middleman-toc", :branch => "master"

gem "normalize-scss"
gem "bourbon"
gem "neat"

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
