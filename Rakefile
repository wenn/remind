require "rake/testtask"
require "rake"

task :build do
    puts `gem build remind.gemspec`
end

task :install do
    puts `gem install remind-1.0.0.gem`
end

task :package do
    Rake::Task[:build].invoke and Rake::Task[:install].invoke
end


Rake::TestTask.new(:test) do |t|
  t.libs << File.expand_path('test/helper.rb')
  t.libs << File.expand_path('lib/')
  t.test_files = FileList['test/test*.rb'].map { |f| File.expand_path(f) }
  t.verbose = true
end

task :default => [:package]
