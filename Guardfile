# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'livereload' do
#  watch(%r{config/locales/.+\.yml})
  watch(%r{lib/.+\.rb})
  watch(%r{lib/scraper/.+\.rb})
  watch(%r{lib/scraper/edgar/.+\.rb})
end

guard 'cucumber' do
  watch(%r{^spec/features/(.+)\.feature$})
end

guard 'rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }

  # Turnip features and steps
  watch(%r{^spec/acceptance/(.+)\.feature$})
  watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$})   { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'spec/acceptance' }
  
  watch(%r{^features/.+\.feature$})
  watch(%r{^features/support/.+$})                      { 'features' }
  watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }
end

