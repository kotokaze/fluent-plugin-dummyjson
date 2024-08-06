lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name    = "fluent-plugin-dummyjson"
  spec.version = "0.1.1"
  spec.authors = ["kotokaze"]
  spec.email   = ["62094392+kotokaze@users.noreply.github.com"]

  spec.summary       = "Fluentd plugin to fetch dummy JSON data"
  spec.homepage      = "https://github.com/kotokaze/fluent-plugin-dummyjson"
  spec.license       = "Apache-2.0"

  test_files, files  = `git ls-files -z`.split("\x0").partition do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.files         = files
  spec.executables   = files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = test_files
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.4.19"
  spec.add_development_dependency "rake", "~> 13.1.0"
  spec.add_development_dependency "test-unit", "~> 3.5.7"
  spec.add_runtime_dependency "fluentd", [">= 0.14.10", "< 2"]
end
