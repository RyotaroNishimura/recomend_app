require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage = :fog
    config.fog_provider = 'fog/aws'
    config.fog_directory  = '[toikke]'
    config.asset_host = 'https://s3-ap-northeast-1.amazonaws.com/[toikke]'
    config.fog_public = false
    config.fog_credentials = {

      provider: 'AWS',
      region: ENV['S3_REGION'],
      aws_access_key_id: ENV['S3_ACCESS_KEY'],
      aws_secret_access_key: ENV['S3_SECRET_KEY']
    }
    config.fog_directory     = ENV['S3_BUCKET']
  else
    config.storage :file
  end

end

