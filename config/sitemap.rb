# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://www.psymic.com"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
  add channels_path
  add wiki_pages_path
  User.find_each do |content|
    add user_path(content), :lastmod => content.updated_at
  end
  Channel.find_each do |content|
    add channel_path(content), :lastmod => content.updated_at
  end
  WikiPage.find_each do |content|
    add wiki_page_path(content), :lastmod => content.updated_at
  end
  Mindlog.published.find_each do |content|
    add mindlog_path(content), :lastmod => content.updated_at
  end
end

