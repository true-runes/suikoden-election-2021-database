Bugsnag.configure do |config|
  if Rails.env.in?(['production', 'staging', 'development'])
    config.api_key = ENV['BUGSNAG_API_KEY']
  end
end
