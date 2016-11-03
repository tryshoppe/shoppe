$LOAD_PATH.push File.expand_path('../lib', __FILE__)

require 'shoppe/version'

Gem::Specification.new do |s|
  s.name        = 'shoppe'
  s.version     = Shoppe::VERSION
  s.authors     = ['Adam Cooke', 'Dean Perry', 'Sahidur Rahman Suman']
  s.email       = ['adam@atechmedia.com', 'dean@voupe.com', 'suman5040@gmail.com']
  s.homepage    = 'http://tryshoppe.com'
  s.summary     = 'Just an e-commerce platform.'
  s.licenses    = ['MIT']
  s.description = 'A full Rails engine providing e-commerce functionality for any Rails 5 application.'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '5.0.0.1'
  s.add_dependency 'bcrypt', '3.1.11'
  s.add_dependency 'ransack', '1.8.2'
  s.add_dependency 'kaminari', '0.17.0'
  s.add_dependency 'haml', '4.0.7'
  s.add_dependency 'dynamic_form', '1.1.4'
  s.add_dependency 'jquery-rails', '4.2.1'
  s.add_dependency 'roo', '2.5.1'
  s.add_dependency 'awesome_nested_set', '3.1.1'
  # s.add_dependency 'globalize', branch: 'master'

  s.add_dependency 'nifty-key-value-store', '1.0.2'
  s.add_dependency 'nifty-utils', '1.1.7'
  s.add_dependency 'nifty-dialog', '1.1.1'
  s.add_dependency 'carrierwave', '0.11.2'
  s.add_dependency 'fog', '1.38.0'
  s.add_dependency 'net-ssh', '3.2.0'
  s.add_dependency 'mini_magick', '4.5.1'
  s.add_dependency 'json', '1.8.3'

  s.add_development_dependency 'coffee-rails', '4.2.1'
  s.add_development_dependency 'sass-rails', '5.0.6'
  s.add_development_dependency 'sqlite3', '1.3.12'
  s.add_development_dependency 'mysql2', '~> 0.3'
  s.add_development_dependency 'yard', '0.9.5'
  s.add_development_dependency 'yard-activerecord', '0.0.16'
  s.add_development_dependency 'markdown', '1.2.0'
  s.add_development_dependency 'factory_girl_rails', '4.7.0'
end
