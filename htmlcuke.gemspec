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
  spec.summary       = %q{Cucumber formatter that works to provide html reports for specific automation needs}
  spec.description   = %q{This is for the reporting needs given to me while working at my current company}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.add_dependcy 'cucumber'

  s.post_install_message = <<-EOS

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
