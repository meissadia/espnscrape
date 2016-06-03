Gem::Specification.new do |s|
  s.name        = 'espnscrape'
  s.version     = '0.1.1'
  s.date        = Date.today.to_s
  s.summary     = "Programmatic access to sports data"
  s.description = %Q(  (Currently NBA ONLY) Updated for the 2016 site redesign. EspnScrape allows you to easily integrate logistic and statistical information about your favorite sports and teams in your own development projects. Easily access data via Structs (dot notation!), Hashes (can be passed directly to ActiveRecord) or String arrays.)
  s.authors     = ["Meissa Dia"]
  s.email       = 'meissadia@gmail.com'
  s.files       = Dir.glob("{bin,lib}/**/*")
  s.platform    = Gem::Platform.local
  s.homepage    = 'https://github.com/meissadia/espnscrape'
  s.license     = 'GNU GPLv3'
  s.add_runtime_dependency 'nokogiri', '~> 1.6'
  s.add_development_dependency "minitest", '~> 0'
  # s.executables  = ['bundle']
end
