require './lib/magic_cloud/version'
 
Gem::Specification.new do |s|
  s.name = 'magic_cloud'
  s.version = MagicCloud::VERSION
  s.authors = ['Victor Shepelev']
  s.email = 'zverok.offline@gmail.com'
  s.description = <<-EOF
    Simple, pure-ruby library for making pretty Wordle-like clouds.
    It uses RMagick as graphic backend.
  EOF
  s.summary = 'Pretty word cloud maker for Ruby'
  s.homepage = 'http://github.com/zverok/magic_cloud'
  s.licenses = ['MIT']

  s.files = `git ls-files`.split($RS).reject do |file|
    file =~ /^(?:
    spec\/.*
    |Gemfile
    |Rakefile
    |\.rspec
    |\.gitignore
    |\.rubocop.yml
    |\.rubocop_todo.yml
    |\.travis.yml
    |.*\.eps
    )$/x
  end
  s.executables = s.files.grep(/^bin\//) { |f| File.basename(f) }
  
  s.require_paths = ["lib"]
  s.rubygems_version = '2.2.2'
  
  s.add_dependency 'rmagick'
  s.add_dependency 'slop', '~> 3.0.0' # for bin/magic_cloud options parsing
  
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'ruby-prof'
end
