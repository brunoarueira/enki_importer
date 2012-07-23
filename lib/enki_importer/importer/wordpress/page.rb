module Enki
  module Importer
    module Wordpress
      module Page
        def import_pages
          xml = File.read(self.file_to_import_data)

          parser = XML::Parser.new
          parser.string = xml

          document = parser.parse

          pages = []

          library = load_library_pages

          document.find('//item').each do |wp_page|
            post_type = wp_page.find_first('wp:post_type').content

            if post_type == "page"
              pages << library.inject({}) { |record,attribute| record[attribute[1]] = wp_page.find(attribute[0]).first.content; record }
            end
          end

          pages.each do |page|
            pages_founded = ::Page.find_by_title(page['title'])

            if pages_founded.nil? then
              begin
                puts "Page is importing: #{page['title']}"

                ::Page.create!(page)
              rescue Exception => e
                puts "#{e.message}"
              end
            else
              puts "Page #{page['title']} already exists."
            end
          end

          puts "Pages imported successfully."
        end

        def load_library_pages
            library = {}

            library["title"] = "title"
            library["content:encoded"] = "body"
            library["wp:post_name"] = "slug"
            library["wp:post_date"] = "created_at"

            library
        end
      end
    end
  end
end