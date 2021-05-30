Bugsnag.configure do |config|
  # TODO: 運用が落ち着いてきたら環境を絞る
  if true | Rails.env.in?(['production', 'staging'])
    config.api_key = ENV['BUGSNAG_API_KEY']
  end
end
