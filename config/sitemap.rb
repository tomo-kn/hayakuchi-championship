# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://hayakuchi-championship.com"

SitemapGenerator::Sitemap.create({ search_engines: {:google=>"http://www.google.com/webmasters/tools/ping?sitemap=%s", :bing=>"https://www.bing.com/webmasters/about?siteUrl="} }) do
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
  Sentence.find_each do |practice|
    add practice_path(practice), :lastmod => practice.updated_at
  end

  # その他sitemapに登録したいページ(=非ログイン時に読み込めるページ)
  add '/game'
  add '/rank'
  add '/login'
  add '/users/new'
  add '/terms'
  add '/policy'
  add '/contact'

end
