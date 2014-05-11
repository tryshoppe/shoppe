$:.push File.expand_path("../lib", __FILE__)

require "shoppe/version"

Gem::Specification.new do |s|
  s.name        = "shoppe"
  s.version     = Shoppe::VERSION
  s.authors     = ["Adam Cooke"]
  s.email       = ["adam@niftyware.io"]
  s.homepage    = "http://tryshoppe.com"
  s.summary     = "Just an e-commerce platform."
  s.description = "A full Rails engine providing e-commerce functionality for any Rails 4 application."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", ">= 4.0.1"
  s.add_dependency "bcrypt-ruby", "~> 3.1.2"
  s.add_dependency "ransack", ">= 1.0.0"
  s.add_dependency "kaminari", ">= 0.14.1", "< 0.16"
  s.add_dependency "haml", "~> 4.0.3"  
  s.add_dependency "dynamic_form", "~> 1.1.4"
  s.add_dependency "jquery-rails", ">= 3.0.4"
  s.add_dependency "coffee-rails", ">= 4.0.0"
  s.add_dependency "sass-rails", ">= 4.0.0"
  s.add_dependency "uglifier", ">= 2.2.0"

  s.add_dependency "nifty-key-value-store", "~> 1.0.0"
  s.add_dependency "nifty-utils", "~> 1.0.0"
  s.add_dependency "nifty-attachments", "~> 1.0.0"
  s.add_dependency "nifty-dialog", "~> 1.0.0"
  
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "mysql2"
  s.add_development_dependency 'yard'
  s.add_development_dependency "yard-activerecord"
  s.add_development_dependency "markdown"
  s.add_development_dependency "factory_girl_rails", '~> 4.0'
end
