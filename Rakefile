begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

APP_RAKEFILE = File.expand_path("../test/app/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'

Bundler::GemHelper.install_tasks

require 'rake/testtask'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

namespace :shoppe do
  desc 'Publish the release notes'
  task :changelog do
    system "scp -P 32032 CHANGELOG.md vdt@185.44.252.32:/app/docs/CHANGELOG.md"
  end

  desc "Publish RDoc documentation from doc to api.tryshoppe.com"
  task :docs do
    if File.exist?('Rakefile')
      system "yard"
      system "ssh root@tryshoppe.com rm -Rf /var/www/shoppe-api"
      system "scp -r doc root@tryshoppe.com:/var/www/shoppe-api"
      system "rm -Rf doc"
    end
  end
end

