require "enki_importer/version"

module Enki
  module Importer
    require "enki_importer/railtie" if defined?(Rails)
  end
end
