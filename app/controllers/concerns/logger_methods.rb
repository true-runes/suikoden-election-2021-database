# TODO: 命名を再考
module LoggerMethods
  extend ActiveSupport::Concern

  module ModuleMethods
    def convert_hash_to_json(options={})
      {
        app_name: ENV['APP_NAME_FOR_LOGGER'] || options[:app_name] || '',
        message: options[:message] || '',
        time: Time.zone.now.to_s
      }.merge(options).to_json
    end

    def convert_tweet_objects_to_array(tweets)
      converted_array_from_tweet_objects = []

      # 長すぎると Papertrail が記録してくれない
      tweets.each do |tweet|
        inserted_hash = {
          id_number: tweet.id_number,
          # user_name: tweet.user.name,
          screen_name: tweet.user.screen_name,
          # full_text: tweet.full_text,
          # is_retweet: tweet.is_retweet,
          url: tweet.url,
          tweeted_at: tweet.tweeted_at
          # media_exists: tweet.has_assets?,
          # is_public: tweet.is_public?,
          # is_mentioned_to_gensosenkyo_admin: tweet.is_mentioned_to_gensosenkyo_admin?
        }

        converted_array_from_tweet_objects << inserted_hash
      end

      converted_array_from_tweet_objects
    end
  end

  extend ModuleMethods
end
