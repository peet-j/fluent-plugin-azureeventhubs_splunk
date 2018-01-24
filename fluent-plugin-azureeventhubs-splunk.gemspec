# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-azureeventhubs_splunk"
  spec.version       = "0.0.1"
  spec.authors       = ["James Peet"]
  spec.email         = ["james.peet@amido.com"]
  spec.summary       = "Forwards Fluentd output to Azure EventHubs in Splunk format"
  spec.description   = "Forwards Fluentd output to Azure EventHubs in Splunk format. Forked from https://github.com/htgc/fluent-plugin-azureeventhubs"
  spec.homepage      = "https://github.com/peet-j/fluent-plugin-azureeventhubs_splunk"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "fluentd", [">= 0.14.15", "< 2"]
end
