module ApplicationHelper
  def default_meta_tags
    {
      site: '早口言葉選手権',
      title: '',
      reverse: true,
      charset: 'utf-8',
      description: 'あなたの早口言葉を採点します。試合モードでライバルとスコアを競え！',
      keywords: '早口言葉,早口言葉選手権',
      canonical: request.original_url,
      separator: '|',
      viewport: 'width=device-width,initial-scale=1,viewport-fit=cover',
      icon: [
        { href: image_url('favicon.ico')},
        { href: image_url('icon.jpg'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/jpg' },
      ],
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('hayakuchi-championship-toppage.png'),
        locale: 'ja_JP',
      },
      twitter: {
        card: 'summary_large_image',
        site: '@tomokn5',
      }
    }
  end
end
