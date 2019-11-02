lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "fast_matrix/version"

Gem::Specification.new do |spec|
  spec.name          = "fast_matrix"
  spec.version       = FastMatrix::VERSION
  spec.authors       = ["mmcs_ruby"]
  spec.email         = ["poganesyan@sfedu.ru"]

  spec.summary       = %q{Ruby wrapper around C matrices implementation}
  spec.description   = %q{Ruby wrapper around C matrices implementation}
  spec.homepage      = "https://github.com/mmcs-ruby/fast_matrix/wiki"
  spec.license       = "MIT"

   spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/mmcs-ruby/fast_matrix"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.extensions    = ["ext/fast_matrix/extconf.rb"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rake-compiler"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency 'simplecov'
end
