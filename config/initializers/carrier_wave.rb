CarrierWave.configure do |config|
  config.fog_credentials = {
      :provider => 'AWS',
      :aws_access_key_id => ENV["ACCESS_KEY_ID"],
      :aws_secret_access_key => ENV["SECRET_ACCESS_KEY"],
      :region => ENV["AWS_REGION"] # Change this for different AWS region. Default is 'us-east-1'
  }
  if Rails.env.production?
    config.root = Rails.root.join('tmp')
    config.cache_dir = "#{Rails.root}/tmp/uploads"
  end
  config.storage = :fog
  config.fog_directory = ENV["S3_BUCKET_NAME"]
  config.fog_public = false
end