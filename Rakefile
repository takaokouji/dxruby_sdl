require "bundler/gem_tasks"
require "rspec/core/rake_task"

if /darwin/ =~ RUBY_PLATFORM
  task :spec do
    sh "rsdl -S rspec #{ENV['SPEC_OPTS']} #{ENV['SPEC']}"
  end
else
  RSpec::Core::RakeTask.new(:spec)
end

task :rubocop do
  files = `git ls-files | grep -e '.rb$'`
  sh "rubocop #{files.split(/\s+/m).join(' ')}"
end

task :default => [:rubocop, :spec]
