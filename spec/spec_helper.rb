#dir = "./lib"
#$LOAD_PATH.unshift(dir)
#$LOAD_PATH.unshift(File.dirname(__FILE__))
#$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
Dir[File.join("./lib", "*.rb")].each {|file| require File.basename(file) }

RSpec.configure do |config|
  # Use color in STDOUT
  config.color_enabled = true
  # Use color not only in STDOUT but also in pagers and files
  config.tty = true
  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate
end

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end