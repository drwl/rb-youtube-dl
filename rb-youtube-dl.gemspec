# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'youtube-dl/version'

Gem::Specification.new do |spec|
  spec.name          = 'rb-youtube-dl'
  spec.version       = RbYoutubeDL::VERSION
  spec.authors       = ['drwl', 'sapslaj', 'xNightMare']
  spec.email         = ['git@drewlee.com']
  spec.summary       = <<~SUMMARY.strip
    Ruby wrapper for youtube-dl, forked from youtube-dl.rb
  SUMMARY
  spec.description   = <<~DESCRIPTION.strip
    in the spirit of pygments.rb and MiniMagick, youtube-dl.rb is a command line wrapper for the python script youtube-dl
  DESCRIPTION
  spec.homepage      = 'https://github.com/drwl/rb-youtube-dl'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["bug_tracker_uri"] = "https://github.com/drwl/rb-youtube-dl/issues"

  spec.files         = Dir['LICENSE.txt', 'README.md', 'lib/**/*', 'vendor/**/*']
  spec.bindir        = "vendor/bin"
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'terrapin', '>= 0.6.0'

  spec.add_development_dependency 'bundler', '>= 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-retry'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
end
