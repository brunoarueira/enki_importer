module Enki
  module Importer
    module Wordpress
      module Tag
        def import_tags
          xml = File.read(self.file_to_import_data)

          parser = XML::Parser.new
          parser.string = xml

          document = parser.parse

          tags = []

          library = load_library_tags

          document.find('//wp:tag').each do |wp_tag|
            tags << library.inject({}) { |record,attribute| record[attribute[1]] = wp_tag.find(attribute[0]).first.content; record }
          end

          tags.each do |tag|
            tags_founded = ::Tag.find_by_name(tag['name'])

            if tags_founded.nil? then
              begin
                puts "Tag is importing: #{tag['name']}"

                ::Tag.create!(tag)
              rescue Exception => e
                puts "#{e.message}"
              end
            else
              puts "Tag #{tag['name']} already exists."
            end
          end

          puts "Tags imported successfully!"
        end

        def load_library_tags
          library = {}

          library["wp:tag_name"] = "name"

          library
        end
      end
    end
  end
end