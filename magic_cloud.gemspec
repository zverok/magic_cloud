require './lib/magic_cloud/version'
 
Gem::Specification.new do |s|
  s.name = "magic_cloud"
  s.version = MagicCloud::VERSION
  s.authors = ["Victor Shepelev"]
  s.date = Time.now.utc.strftime("%Y-%m-%d")
  s.email = "zverok.offline@gmail.com"
  s.files = `git ls-files`.split("\n")
  s.homepage = %q{http://github.com/zverok/magic_cloud}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{2.2.2}
  s.summary = %q{Wordle-like word cloud layout, using RMagick as drawing engine}
  
  s.add_dependency 'rmagick'
  s.add_dependency 'slop', '~> 3.0.0' # for bin/magic_cloud options parsing
  
  s.add_development_dependency 'rubocop'
end
