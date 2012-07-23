require 'rubygems'
require 'xml'
require File.expand_path('../page', __FILE__)
require File.expand_path('../post', __FILE__)
require File.expand_path('../tag', __FILE__)
require File.expand_path('../comment', __FILE__)

module Enki
  module Importer
    module Wordpress
      class Base
        class << self
          include Enki::Importer::Wordpress::Page
          include Enki::Importer::Wordpress::Post
          include Enki::Importer::Wordpress::Tag
          include Enki::Importer::Wordpress::Comment

          attr_accessor :file_to_import_data

          def import(import_type=:tags, file_to_import_data=nil)
            if !file_to_import_data.nil?
              self.file_to_import_data = file_to_import_data

              self.send("import_#{import_type.to_s}")
            else
              puts "The file path is needed to import #{import_type.to_s}."
            end
          end
        end
      end
    end
  end
end