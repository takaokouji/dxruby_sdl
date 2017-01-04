# -*- coding: utf-8 -*-

require 'coveralls'
Coveralls.wear!

require 'rspec/its'
require 'rspec/collection_matchers'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'dxruby_sdl'

Dir.glob(File.expand_path('../support/**/*.rb', __FILE__)).each do |path|
  require path
end

RSpec.configure do |config|
  config.before(:each) do
    DXRubySDL::Input.instance_variable_set('@keys', Set.new)
    DXRubySDL::Input.instance_variable_set('@checked_keys', Set.new)
    DXRubySDL::Input.instance_variable_set('@down_keys', Set.new)
    DXRubySDL::Input.instance_variable_set('@joysticks', [])
  end
end
