$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "transam_audit/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "transam_audit"
  s.version     = TransamAudit::VERSION
  s.authors     = ["Julian Ray"]
  s.email       = ["jray@camsys.com"]
  s.homepage    = "http://www.camsys.com"
  s.summary     = "Auditing Extensions for TransAM."
  s.description = "Auditing Extensions for TransAM."
  s.license     = "MIT"

  s.metadata = { "load_order" => "30" }

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency 'rails', '>=4.1.9'

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "mysql2"
  s.add_development_dependency "cucumber-rails"
  s.add_development_dependency "shoulda-matchers"
  s.add_development_dependency "codacy-coverage"
  s.add_development_dependency "simplecov"
end
