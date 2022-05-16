module TwitterRestApi
  class CheckPublicTweets
    include LoggerMethods

    INTERVAL_SECONDS = 5

    def initialize(consumer_key: nil, consumer_secret: nil, access_token: nil, access_secret: nil)
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = consumer_key || ENV.fetch('TWITTER_CONSUMER_KEY', nil)
        config.consumer_secret     = consumer_secret || ENV.fetch('TWITTER_CONSUMER_SECRET', nil)
        config.access_token        = access_token || ENV.fetch('TWITTER_ACCESS_TOKEN', nil)
        config.access_token_secret = access_secret || ENV.fetch('TWITTER_ACCESS_SECRET', nil)
      end
    end

    def update_all_tweet_is_public_statuses
      set_not_public_tweet_id_numbers_and_public_tweet_id_numbers

      # 公開ツイート -> 鍵ツイート or 削除ツイート
      ActiveRecord::Base.transaction do
        Tweet.where(id_number: @not_public_tweet_id_numbers).each do |tweet|
          tweet.update!(is_public: false) if tweet.public?
        end
      end

      # 鍵ツイート -> 公開ツイート
      ActiveRecord::Base.transaction do
        Tweet.where(id_number: @public_tweet_id_numbers).each do |tweet|
          tweet.update!(is_public: true) unless tweet.public?
        end
      end
    end

    # https://developer.twitter.com/en/docs/twitter-api/v1/tweets/post-and-engage/api-reference/get-statuses-lookup
    # A comma separated list of Tweet IDs, up to 100 are allowed in a single request.
    # Requests / 15-min window (app auth): 300 #=> 1分に20回まで
    def set_not_public_tweet_id_numbers_and_public_tweet_id_numbers
      not_public_tweet_id_numbers = []

      # データベースに保存してある id_number のツイートを一挙取得して、戻り値に存在するかどうかで public かそうでないかを判断する
      # TODO: 並び順の一意性の確保のため、order(id_number: :asc)
      Tweet.order(tweeted_at: :asc).pluck(:id_number).each_slice(100) do |sliced_all_id_numbers|
        sliced_id_numbers_tweets_id_numbers = @client.statuses(sliced_all_id_numbers).map(&:id)
        not_public_tweet_id_numbers_in_this_sliced_id_numbers = sliced_all_id_numbers - sliced_id_numbers_tweets_id_numbers

        not_public_tweet_id_numbers << not_public_tweet_id_numbers_in_this_sliced_id_numbers
        not_public_tweet_id_numbers.flatten!

        sleep INTERVAL_SECONDS
      end

      @not_public_tweet_id_numbers = not_public_tweet_id_numbers
      @public_tweet_id_numbers = Tweet.all.pluck(:id_number) - not_public_tweet_id_numbers
    end
  end
end
