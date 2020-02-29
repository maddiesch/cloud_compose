lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cloud_compose/version'

Gem::Specification.new do |spec|
  spec.name          = 'cloud_compose'
  spec.version       = CloudCompose::VERSION
  spec.authors       = ['Maddie Schipper']
  spec.email         = ['me@maddiesch.com']

  spec.summary       = ''
  spec.description   = ''
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = Dir['{app,config,db,lib,exe}/**/*', 'Rakefile', 'README.md']
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler',   '~> 2.0'
  spec.add_development_dependency 'pry',       '~> 0.12'
  spec.add_development_dependency 'rake',      '~> 13.0'
  spec.add_development_dependency 'rspec',     '~> 3.8'
  spec.add_development_dependency 'simplecov', '~> 0.16'
  spec.add_development_dependency 'yard',      '~> 0.9'
end
