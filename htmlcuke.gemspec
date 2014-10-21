# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'htmlcuke/version'

Gem::Specification.new do |spec|
  spec.name          = "htmlcuke"
  spec.version       = Htmlcuke::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ["Nathan Ray"]
  spec.email         = ["ntray1@gmail.com"]
  spec.summary       = %q{See https://github.com/maizaAvaro/Htmlcuke for a description and usage case}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/maizaAvaro/Htmlcuke"
  spec.license       = "MIT"

  spec.add_dependency 'cucumber'

  spec.post_install_message = <<-EOS

  -------------------------------------------
  | To use this formatter:                  |
  |                                         |
  | Add --format 'Htmlcuke::Formatter' to   |
  | to your cucumber.yml, Rakefile, or on   |
  | the command line after your arguments   |
  -------------------------------------------

EOS

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
end
