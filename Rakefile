require 'bundler/gem_helper'
require "rspec/core/rake_task"

if /darwin/ =~ RUBY_PLATFORM
  task :spec do
    sh "rsdl -S rspec #{ENV['SPEC_OPTS']} #{ENV['SPEC']}"
  end

  task :guard do
    rspec_path = 'spec/rspec'
    File.open(rspec_path, 'w') do |f|
      f.write(<<-EOS)
#!/bin/sh
bundle exec rsdl -S rspec $@
      EOS
    end
    chmod(0755, rspec_path)
    begin
      sh "bundle exec guard"
    ensure
      rm_rf(rspec_path)
    end
  end
else
  RSpec::Core::RakeTask.new(:spec)

  task :guard do
    sh "bundle exec guard"
  end
end

task :rubocop do
  files = `git ls-files | grep -e '.rb$'`
  sh "rubocop #{files.split(/\s+/m).join(' ')}"
end

namespace :gem do
  Bundler::GemHelper.install_tasks
end

task :build do
  Rake::Task['gem:build'].invoke
end

task :release do
  Rake::Task['gem:release'].invoke

  require 'dxruby_sdl/version'
  next_version = DXRubySDL::VERSION.split('.').tap { |versions|
    versions[-1] = (versions[-1].to_i + 1).to_s
  }.join('.')
  File.open('lib/dxruby_sdl/version.rb', 'r+') do |f|
    lines = []
    while line = f.gets
      line = "#{$1}'#{next_version}'\n" if /(\s*VERSION =\s*)/.match(line)
      lines << line
    end
    f.rewind
    f.write(lines.join)
  end
  sh 'git add lib/dxruby_sdl/version.rb'
  sh "git commit -m #{next_version}"
  sh 'git push'
end

task :default => [:spec]
