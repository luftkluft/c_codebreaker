# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'c_codebreaker/version'

Gem::Specification.new do |spec|
  spec.name          = 'c_codebreaker'
  spec.version       = CCodebreaker::VERSION
  spec.authors       = ['luft kluft']
  spec.email         = ['luftkluft@gmail.com']

  spec.summary       = 'Console app codebreaker.'
  spec.homepage      = 'https://github.com/luftkluft/c_codebreaker'
  spec.license       = 'MIT'

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
