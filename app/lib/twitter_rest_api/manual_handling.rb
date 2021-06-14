# rails console で扱うこと前提（手動調査など）
# > client = TwitterRestApi::ManualHandling.client
# > client.user('gensosenkyo')
# > client.search('#幻水総選挙2021', since_id: 12345, max_id: 13456, tweet_mode: :extend)

module TwitterRestApi
  class ManualHandling
    def self.client(consumer_key: nil, consumer_secret: nil, access_token: nil, access_secret: nil)
      Twitter::REST::Client.new do |config|
        config.consumer_key        = consumer_key || ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret     = consumer_secret || ENV['TWITTER_CONSUMER_SECRET']
        config.access_token        = access_token || ENV['TWITTER_ACCESS_TOKEN']
        config.access_token_secret = access_secret || ENV['TWITTER_ACCESS_SECRET']
      end
    end
  end
end
