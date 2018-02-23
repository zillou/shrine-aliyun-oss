Gem::Specification.new do |spec|
  spec.name          = "shrine-aliyun-oss"
  spec.version       = "0.1.0.beta1"
  spec.authors       = ["Derrick Zhang"]
  spec.email         = ["robot@zillou.me"]

  spec.summary       = "Provides Aliyun OSS storage for Shrine."
  spec.homepage      = "https://github.com/zillou/shrine-aliyun-oss"
  spec.files         = Dir["README.md", "LICENSE", "lib/**/*.rb", "shrine-aliyun-oss.gemspec"]

  spec.require_paths = ["lib"]
  spec.license       = "MIT"

  spec.add_dependency "shrine", "~> 2.2"
  spec.add_dependency "aliyun-sdk", "~> 0.5.0"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
