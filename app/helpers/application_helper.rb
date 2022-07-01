module ApplicationHelper
  def default_meta_tags
    {
      site: '早口言葉選手権',
      title: title,
      reverse: true,
      charset: 'utf-8',
      description: '早口言葉を採点します！採点モードでライバルと競え！',
      keywords: '早口言葉,早口言葉選手権',
      canonical: request.original_url,
      separator: '|',
      viewport: 'width=device-width,initial-scale=1,viewport-fit=cover',
      icon: [
        { href: image_url(''), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/png' },
        { href: image_url('favicon.ico')}
      ],
      og: {
        title: :site,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url(''),
        locale: 'ja_JP'
      },
      twitter: {
        card: 'summary_large_image'
      }
    }
  end
end
