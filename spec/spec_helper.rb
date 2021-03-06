ENV["RACK_ENV"] ||= "test"
require "bundler"
Bundler.require(:default, :test)

ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..')).freeze
$LOAD_PATH << ROOT

require 'app'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'
end
