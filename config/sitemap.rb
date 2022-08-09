# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://hayakuchi-championship.com"

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

  # '/practices' を追加する
    add practices_path, :priority => 0.7, :changefreq => 'daily'
  
  # '/practices/:id' を追加する 
  
    Practice.find_each do |practice|
      add practice_path(practice), :lastmod => practice.updated_at
    end
end
