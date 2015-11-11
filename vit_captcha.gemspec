# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vit_captcha/version'

Gem::Specification.new do |spec|
  spec.name          = "vit_captcha"
  spec.version       = VitCaptcha::VERSION
  spec.authors       = ["Hadi Nishad"]
  spec.email         = ["hadinishad42@gmail.com"]
  spec.summary       = %q{Solves CAPTCHA on VIT Academics page}
  spec.description   = %q{Ruby port of VIT AutoCaptcha}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'rmagick'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
