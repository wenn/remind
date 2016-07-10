Gem::Specification.new do |s|
  s.name        = "remind"
  s.version     = "1.0.0"
  s.date        = "2016-07-04"
  s.summary     = "Trello, but better"
  s.authors     = ["Nguyen Nguyen"]
  s.email       = "nnguyen920@gmail.com "
  s.files       = `git ls-files -z`.split("\x0").select { |f| f[%r{^lib/}] }
  s.homepage    = "https://github.com/"
  s.license     = "MIT"
  s.executables = ["remind", "remind-alert", "remind-setup"]
  s.post_install_message = "Run remind-setup to complete installation!"

  s.add_runtime_dependency("chronic", "0.10.2")
  s.add_runtime_dependency("textbelt", "0.1.1")
  s.add_runtime_dependency("whenever", "0.9.7")
end
