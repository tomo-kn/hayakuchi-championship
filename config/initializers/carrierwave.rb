require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

# 保存先の分岐
CarrierWave.configure do |config|
  # 本番環境はS3に保存
  if Rails.env.production?
    config.storage :fog
    config.fog_provider = 'fog/aws'
    config.fog_directory = 'hayakuchi-championship-voice' #バケット名
    config.fog_public = false
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['S3_ACCESS_KEY_ID'], # アクセスキー
      aws_secret_access_key: ENV['S3_SECRET_ACCESS_KEY'], # シークレットアクセスキー
      region: 'ap-northeast-1',
      path_style: true
    }
    # キャッシュをS3に保存
    # config.cache_storage = :fog
  else
    # 開発環境はlocalに保存
    config.asset_host = 'http://localhost:5000'
    config.storage :file
    config.enable_processing = false if Rails.env.test? #test環境は処理をスキップ
  end
end