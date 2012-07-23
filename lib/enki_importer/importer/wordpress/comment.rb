module Enki
  module Importer
    module Wordpress
      module Comment
        def import_comments
          xml = File.read(self.file_to_import_data)

          parser = XML::Parser.new
          parser.string = xml

          document = parser.parse

          comments = []

          library = load_library_comments

          document.find('//item').each do |wp_post|
            post_type = wp_post.find_first('wp:post_type').content
            status = wp_post.find_first('wp:status').content

            if post_type == "post" && status == "publish"
              title = wp_post.find_first("child::title").content

              wp_post.find('wp:comment').each do |wp_comment|
                comments << library.inject({'post_id' => title}) { |record,attribute| record[attribute[1]] = wp_comment.find_first(attribute[0]).content; record }
              end
            end
          end

          comments.each do |comment|
            comments_founded = ::Comment.where("author_email = '#{comment['author_email']}' and body = ?", CGI::unescapeHTML(comment['body']))

            if comments_founded.nil? then
              begin
                puts "Comment is importing: #{comment['post_id']} = #{comment['author']}"

                comment["post_id"] = ::Post.find_by_title(comment["post_id"]).id
                comment["body"] = CGI::unescapeHTML(comment["body"])

                ::Comment.create!(comment)
              rescue Exception => e
                puts "#{e.message}"
              end
            else
              puts "Comment on #{comment['post_id']} by #{comment['author']} with the same content already exists."
            end
          end
        end

        def load_library_comments
            library = {}

            library["wp:comment_author"] = "author"
            library["wp:comment_author_email"] = "author_email"
            library["wp:comment_author_url"] = "author_url"
            library["wp:comment_date"] = "created_at"
            library["wp:comment_content"] = "body"

            library
        end
      end
    end
  end
end