# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'procfile_upstart_exporter/version'

Gem::Specification.new do |spec|
  spec.name          = 'procfile-upstart-exporter'
  spec.version       = ProcfileUpstartExporter::VERSION
  spec.authors       = ['Das Dad']
  spec.email         = ['dev@dasdad.com.br']
  spec.description   = %q{Export Procfile entries to Upstart jobs.}
  spec.summary       = %q{Export Procfile entries to Upstart jobs.}
  spec.homepage      = 'https://github.com/dasdad/procfile-upstart-exporter'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'thor'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 2.14'
end
