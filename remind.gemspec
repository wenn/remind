Gem::Specification.new do |s|
  s.name        = 'remind'
  s.version     = '1.0.0'
  s.date        = '2016-07-04'
  s.summary     = "Trello, but better"
  s.authors     = ["Nguyen Nguyen"]
  s.email       = 'nnguyen920@gmail.com '
  s.files       = `git ls-files -z`.split("\x0").select { |f| f[%r{^lib/}] }
  s.homepage    = "https://github.com/"
  s.license     = 'MIT'
  s.executables = 'remind'
end
