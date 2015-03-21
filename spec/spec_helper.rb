require "bundler"
Bundler.setup

require "middleman"

Dir["./lib/*"].each { |f| require f }
