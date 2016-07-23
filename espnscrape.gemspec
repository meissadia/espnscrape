require_relative 'lib/espnscrape'

Gem::Specification.new do |s|
  s.name        = 'espnscrape'
  s.version     = EspnScrape::VERSION
  s.date        = Date.today.to_s
  s.summary     = 'Programmatic access to NBA statistical data'
  s.description = %((NBA ONLY) Updated for the 2016 site redesign. EspnScrape allows you to easily integrate logistic and statistical information about your favorite sports and teams in your own development projects. Easily access data via Structs for dot notation, Hashes for ActiveRecord integration or String arrays. + 0.6.1 - Bug fix for Schedule)
  s.authors     = ['Meissa Dia']
  s.email       = ['meissadia@gmail.com']
  s.files       = Dir.glob('{bin,lib}/**/*') + ['README.md', 'LICENSE', '.yardopts', 'Rakefile', 'CHANGELOG.md']
  s.platform    = Gem::Platform.local
  s.homepage    = 'https://github.com/meissadia/espnscrape'
  s.license     = 'GNU GPLv3'
  s.required_ruby_version = '>= 1.9.3'
  s.add_runtime_dependency     'nokogiri', '~> 1.6'
  s.add_runtime_dependency     'json', '< 2.0'
  s.add_development_dependency 'minitest', '~>5.9'
  s.add_development_dependency 'rake', '~> 10.4'
end
