require File.expand_path('../../enki_importer/importer/wordpress/base', __FILE__)

namespace :enki do
  namespace :import do
    desc "Load blog tags to enki."
    task :tags, [:file_to_import_data] => :environment do |task,args|
      Enki::Importer::Wordpress::Base.import :tags, args.file_to_import_data
    end

    desc "Load blog posts to enki."
    task :posts, [:file_to_import_data] => :tags do |task,args|
      Enki::Importer::Wordpress::Base.import :posts, args.file_to_import_data
    end

    desc "Load blog comments to enki."
    task :comments, [:file_to_import_data] => :posts do |task,args|
      Enki::Importer::Wordpress::Base.import :comments, args.file_to_import_data
    end

    desc "load blog pages to enki."
    task :pages, [:file_to_import_data] => :environment do |task, args|
      Enki::Importer::Wordpress::Base.import :pages, args.file_to_import_data
    end

    desc "Load blog all data (tags, posts, pages and comments)."
    task :all => [:pages, :comments]
  end
end