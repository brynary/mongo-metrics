require 'rubygems'
require 'pathname'

mongo_metrics_path = Pathname.new(__FILE__).join("..", "..", "..", "..", "lib").expand_path
$LOAD_PATH.unshift mongo_metrics_path

# Set up gems listed in the Gemfile.
gemfile = File.expand_path('../../Gemfile', __FILE__)
begin
  ENV['BUNDLE_GEMFILE'] = gemfile
  require 'bundler'
  Bundler.setup
rescue Bundler::GemNotFound => e
  STDERR.puts e.message
  STDERR.puts "Try running `bundle install`."
  exit!
end if File.exist?(gemfile)
