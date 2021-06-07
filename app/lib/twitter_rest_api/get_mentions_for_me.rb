# REST API の認証ユーザに対しての mention を収集する
module TwitterRestApi
  class GetMentionsForMe
    include LoggerMethods

    attr_reader :client

    INTERVAL_SECONDS = 5

    def initialize(consumer_key: nil, consumer_secret: nil, access_token: nil, access_secret: nil)
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = consumer_key || ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret     = consumer_secret || ENV['TWITTER_CONSUMER_SECRET']
        config.access_token        = access_token || ENV['TWITTER_ACCESS_TOKEN']
        config.access_token_secret = access_secret || ENV['TWITTER_ACCESS_SECRET']
      end
    end

    # max_id「〜以下」, since_id「〜より大きい」
    # 以下のロジックは mentions_timeline に限らず一般的な search の戻り値全てに用いることができる
    def execute(initial_execution: false)
      all_mention_tweets = []

      # 全取得の場合は tweet の id が大きい方から小さい方へ取得される
      if initial_execution == true
        # 1周目
        mention_tweets = @client.mentions_timeline(
          {
            tweet_mode: 'extended',
            count: 200
          }
        )
        all_mention_tweets += mention_tweets
        min_tweet_id_number_in_mention_tweets_set = mention_tweets.map(&:id).min

        # 2周目以降、取得ツイートが尽きるまで
        # rubocop:disable Style/InfiniteLoop
        while true
          break if min_tweet_id_number_in_mention_tweets_set.blank?

          mention_tweets = @client.mentions_timeline(
            {
              tweet_mode: 'extended',
              max_id: min_tweet_id_number_in_mention_tweets_set - 1,
              count: 200
            }
          )

          break if mention_tweets.blank?

          all_mention_tweets += mention_tweets
          min_tweet_id_number_in_mention_tweets_set = mention_tweets.map(&:id).min
        end
        # rubocop:enable Style/InfiniteLoop
      else
        # 1周目
        max_tweet_id_number_in_already_getting_tweets = Tweet.not_retweet.mentioned_user(User.find_by(id_number: @client.user.id)).order(id_number: :desc).first.id_number

        mention_tweets = @client.mentions_timeline(
          {
            tweet_mode: 'extended',
            since_id: max_tweet_id_number_in_already_getting_tweets,
            count: 200
          }
        )
        all_mention_tweets += mention_tweets
        max_tweet_id_number_in_mention_tweets = mention_tweets.map(&:id).max

        # 2周目以降、取得ツイートが尽きるまで
        # rubocop:disable Style/InfiniteLoop
        while true
          break if max_tweet_id_number_in_mention_tweets.blank?

          mention_tweets = @client.mentions_timeline(
            {
              tweet_mode: 'extended',
              since_id: max_tweet_id_number_in_mention_tweets,
              count: 200
            }
          )

          break if mention_tweets.blank?

          all_mention_tweets += mention_tweets
          max_tweet_id_number_in_mention_tweets = mention_tweets.map(&:id).max
        end
        # rubocop:enable Style/InfiniteLoop
      end

      all_mention_tweets
    end
  end
end
