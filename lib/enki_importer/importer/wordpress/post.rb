module Enki
  module Importer
    module Wordpress
      module Post
        def import_posts
          xml = File.read(self.file_to_import_data)

          parser = XML::Parser.new
          parser.string = xml

          document = parser.parse

          posts = []

          library = load_library_posts

          document.find('//item').each do |wp_post|
            post_type = wp_post.find_first('wp:post_type').content
            status = wp_post.find_first('wp:status').content

            if post_type == "post" && status == "publish"
              post = library.inject({}) { |record, attribute| record[attribute[1]] = wp_post.find(attribute[0]).first.content; record }

              tag_list = []

              wp_post.find('child::category').each do |wp_category|
                domain = wp_category['domain']

                if domain == "post_tag"
                  tag_list << wp_category['nicename']
                end
              end

              post.merge!("tag_list" => tag_list)

              posts << post
            end
          end

          posts.each do |post|
            posts_founded = ::Post.find_by_title(post['title'])

            if posts_founded.nil? then
              begin
                puts "Post is importing: #{post['title']}"

                post["body"] = CGI::unescapeHTML(post["body"])

                ::Post.create!(post)
              rescue Exception => e
                puts "#{e.message}"
              end
            else
              puts "Post #{post['title']} already exists."
            end
          end
        end

        def load_library_posts
            library = {}

            library["title"] = "title"
            library["pubDate"] = "published_at"
            library["content:encoded"] = "body"
            library["wp:post_name"] = "slug"
            library["wp:post_date"] = "created_at"

            library
        end
      end
    end
  end
end