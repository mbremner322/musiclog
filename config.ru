require 'bundler'
Bundler.require

require './app'

Dotenv.load

Cloudinary.config do |config|
  config.cloud_name = 'dfazpx1vg'
  config.api_key = '317924399249264'
  config.api_secret = 'h2I8gOk6UDz0geqJxFGSBdUAUBE'
end

run Sinatra::Application
