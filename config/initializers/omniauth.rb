Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET'],
    {
      image_size: 'bigger',
      include_email: true
    }
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'], provider_ignores_state: true,
    scope: 'user_about_me, public_profile, user_birthday, user_location, email',
    image_size: 'large',
    info_fields: 'name,email,birthday,gender,location, locale'

  provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_SECRET"],
    scope: 'profile, email',
    image_size: '200',
    access_type: 'online',
    name: 'google'
end

OmniAuth.config.on_failure = Proc.new do |env|
  SessionsController.action(:auth_failure).call(env)
end
