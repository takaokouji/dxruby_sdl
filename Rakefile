require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => [:rubocop, :spec]

task :rubocop do
  files = `git ls-files | grep -e '.rb$'`
  sh "rubocop #{files.split(/\s+/m).join(' ')}"
end
