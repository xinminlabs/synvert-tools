require 'rubygems'
require 'bundler'

# Setup load paths
Bundler.require
$: << File.expand_path('../', __FILE__)
$: << File.expand_path('../lib', __FILE__)

require 'dotenv'
Dotenv.load

# Require base
require 'sinatra/base'
require 'active_support/core_ext/string'
require 'active_support/core_ext/array'
require 'active_support/core_ext/hash'
require 'active_support/json'

libraries = Dir[File.expand_path('../lib/**/*.rb', __FILE__)]
libraries.each do |path_name|
  require path_name
end

require 'app/extensions'
require 'app/models'
require 'app/helpers'
require 'app/routes'

module SynvertToolsApp
  class App < Sinatra::Application
    configure do
      disable :method_override
      disable :static

      set :erb, escape_html: true

      set :sessions,
          httponly: true,
          secure: production?,
          secure: false,
          expire_after: 5.years,
          secret: ENV['SESSION_SECRET']
      set :raise_errors, false
    end

    use Rack::Deflater
    use Rack::Standards

    use Routes::Static

    unless settings.production?
      use Routes::Assets
    end

    # Other routes:
    use Routes::Root
  end
end

include SynvertToolsApp::Models
