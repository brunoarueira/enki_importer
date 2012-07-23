# -*- encoding: utf-8 -*-
require File.expand_path('../lib/enki_importer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Bruno Arueira"]
  gem.email         = ["contato@brunoarueira.com"]
  gem.description   = "Enki Importer, import data from Wordpress"
  gem.summary       = "Import data from Wordpress xml to enki"
  gem.homepage      = "https://github.com/brunoarueira/enki_importer"

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "enki_importer"
  gem.require_paths = ["lib"]
  gem.version       = Enki::Importer::VERSION

  gem.add_dependency 'libxml-ruby', '>= 0.8.3'
end
