require 'enki_importer'
require 'rails'

module Enki
  module Importer
    class Railtie < Rails::Railtie
        railtie_name :enki_importer

        rake_tasks do
          load 'tasks/enki_importer.rake'
        end
    end
  end
end