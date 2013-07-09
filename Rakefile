load 'simplecov/railties/tasks.rake'
require "rspec/core/rake_task"
require "cucumber/rake/task"

task :noop do; end
task :default => :spec

# task :stats => "spec:statsetup"

spec_prereq = :noop
desc "Run all specs in spec directory (excluding plugin specs)"
RSpec::Core::RakeTask.new(:spec => spec_prereq)

namespace :spec do
  def types
    dirs = Dir['./spec/**/*_spec.rb'].map { |f| f.sub(/^\.\/(spec\/\w+)\/.*/, '\\1') }.uniq
    Hash[dirs.map { |d| [d.split('/').last, d] }]
  end

  types.each do |type, dir|
    desc "Run the code examples in #{dir}"
    RSpec::Core::RakeTask.new(type => spec_prereq) do |t|
      t.pattern = "./#{dir}/**/*_spec.rb"
    end
  end

  # RCov task only enabled for Ruby 1.8
  if RUBY_VERSION < '1.9'
    desc "Run all specs with rcov"
    RSpec::Core::RakeTask.new(:rcov => spec_prereq) do |t|
      t.rcov = true
      t.pattern = "./spec/**/*_spec.rb"
      t.rcov_opts = '--exclude /gems/,/Library/,/usr/,lib/tasks,.bundle,config,/lib/rspec/,/lib/rspec-,spec'
    end
  end

  task :statsetup do
    require 'rails/code_statistics'
    types.each do |type, dir|
      name = type.singularize.capitalize

      ::STATS_DIRECTORIES << ["#{name} specs", dir]
      ::CodeStatistics::TEST_TYPES << "#{name} specs"
    end
  end
end