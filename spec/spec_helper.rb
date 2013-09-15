# -*- coding: utf-8 -*-

require 'coveralls'
Coveralls.wear!

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'dxruby_sdl'

Dir.glob(File.expand_path('../support/**/*.rb', __FILE__)).each do |path|
  require path
end

RSpec::Mocks::setup(self)
