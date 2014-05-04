# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dxruby_sdl/version'

Gem::Specification.new do |spec|
  spec.name          = 'dxruby_sdl'
  spec.version       = DXRubySDL::VERSION
  spec.authors       = ['Kouji Takao']
  spec.email         = ['kouji.takao@gmail.com']
  spec.description   = %q{`dxruby-sdl` is a ruby library for 2D graphics and game. It has same DXRuby API. It use SDL/Ruby.}
  spec.summary       = %q{2D graphics and game library}
  spec.homepage      = 'https://github.com/takaokouji/dxruby-sdl'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'travis-lint'
  spec.add_development_dependency 'rubocop', '0.15.0'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'guard-rubocop'

  spec.add_runtime_dependency 'rubysdl'
  spec.add_runtime_dependency 'rsdl'
end
