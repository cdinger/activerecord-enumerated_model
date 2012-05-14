# -*- encoding: utf-8 -*-
require File.expand_path('../lib/active_record-enumerated_model/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Christian Dinger"]
  gem.email         = ["cdinger@gmail.com"]
  gem.description   = %q{Creates an enumeration of constants that contain ActiveRecord rows for a static model}
  gem.summary       = %q{Creates an enumeration of constants that contain ActiveRecord rows for a static model}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "activerecord-enumerated_model"
  gem.require_paths = ["lib"]
  gem.version       = ActiveRecord::EnumeratedModel::VERSION

  gem.add_dependency('activerecord', '>= 3.0.0')
end
