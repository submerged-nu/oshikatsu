Rails.application.config.sorcery.submodules = [:external]
Rails.application.config.sorcery.configure do |config|
  config.external_providers = [:google]

  config.google.key = ENV['GOOGLE_CLIENT_ID']
  config.google.secret = ENV['GOOGLE_CLIENT_SECRET']
  config.google.callback_url = "http://localhost:3000/oauths/callback?provider=google"
  config.google.user_info_mapping = { email: "email" }
  
  config.user_config do |user|
    user.authentications_class = Authentication
  end
  config.user_class = 'User'
end
