# A sample Guardfile
# More info at https://github.com/guard/guard#readme

rspec_option = {
  all_after_pass: false,
  all_on_start: false
}
if /darwin/ =~ RUBY_PLATFORM
  rspec_option[:binstubs] = 'spec'
end
guard :rspec, rspec_option do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb') { "spec" }
  watch(%r{^spec/support/(.+)\.rb$}) { "spec" }
end

guard :rubocop, all_on_start: false do
  watch(%r{.+\.rb$})
  watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
end

# Local Variables:
# mode: ruby
# End:
