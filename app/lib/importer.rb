class Importer
  class << self
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    # FIXME: Update をする場合を考える（別途メソッドを作る？）
    def tweet_records_from_tweet_storage(ts_target_tweets, _update: false)
      ActiveRecord::Base.transaction do
        # TweetStorage のオブジェクトは prefix として ts_ を付けている
        ts_target_tweets.each do |ts_target_tweet|
          ###############
          # User
          ###############
          user_attrs = {
            id_number: ts_target_tweet.user.id_number,
            name: ts_target_tweet.user.name,
            screen_name: ts_target_tweet.user.screen_name,
            profile_image_url_https: ts_target_tweet.user.deserialize.profile_image_url_https.to_s,
            is_protected: false,
            born_at: ts_target_tweet.created_at
          }

          user = User.find_by(id_number: user_attrs[:id_number])
          if user.blank?
            new_user = User.new(user_attrs)
            new_user.save!
          end

          ###############
          # Tweet
          ###############
          # TODO: deserialize しているものは、モデルにメソッドを生やす
          tweet_attrs = {
            id_number: ts_target_tweet.id_number,
            full_text: ts_target_tweet.full_text,
            source: ts_target_tweet.source,
            in_reply_to_tweet_id_number: ts_target_tweet.deserialize.in_reply_to_tweet_id,
            in_reply_to_user_id_number: ts_target_tweet.deserialize.in_reply_to_user_id,
            is_retweet: ts_target_tweet.retweet?,
            language: ts_target_tweet.lang,
            is_public: true,
            tweeted_at: ts_target_tweet.tweeted_at,
            user: new_user || user
          }

          tweet = Tweet.find_by(id_number: tweet_attrs[:id_number])

          if tweet.blank?
            new_tweet = Tweet.new(tweet_attrs)
            new_tweet.save!
          else
            next
          end

          ###############
          # Asset
          ###############
          ts_target_tweet.deserialize.media.each do |asset|
            asset_attrs = {
              id_number: asset.id,
              url: asset.media_url_https,
              asset_type: asset.type,
              is_public: true,
              tweet: new_tweet || tweet
            }

            asset = Asset.find_by(id_number: asset_attrs[:id_number])
            if asset.blank?
              new_asset = Asset.new(asset_attrs)
              new_asset.save!
            end
          end

          ###############
          # Hashtag
          ###############
          ts_target_tweet.deserialize.hashtags.each do |hashtag|
            hashtag_attrs = {
              text: hashtag.text,
              tweet: new_tweet || tweet
            }

            hashtag = Hashtag.find_by(
              text: hashtag_attrs[:text],
              tweet_id: (new_tweet || tweet).id
            )
            if hashtag.blank?
              new_hashtag = Hashtag.new(hashtag_attrs)
              new_hashtag.save!
            end
          end

          ###############
          # InTweetUrl
          ###############
          # ツイートの URL ではなく、ツイートに含まれている URL
          ts_target_tweet.deserialize.urls.each do |url|
            in_tweet_url_attrs = {
              text: url.expanded_url.to_s,
              tweet: new_tweet || tweet
            }

            in_tweet_url = InTweetUrl.find_by(
              text: in_tweet_url_attrs[:text],
              tweet_id: (new_tweet || tweet).id
            )
            if in_tweet_url.blank?
              new_in_tweet_url = InTweetUrl.new(in_tweet_url_attrs)
              new_in_tweet_url.save!
            end
          end

          ###############
          # Mention
          ###############
          ts_target_tweet.deserialize.user_mentions.each do |mention|
            mention_attrs = {
              user_id_number: mention.id,
              tweet: new_tweet || tweet
            }

            mention = Mention.find_by(
              user_id_number: mention_attrs[:user_id_number],
              tweet_id: (new_tweet || tweet).id
            )
            if mention.blank?
              new_mention = Mention.new(mention_attrs)
              new_mention.save!
            end
          end
        end
      end
    end
    # rubocop:enable Metrics/PerceivedComplexity
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/MethodLength

    def direct_message_records_from_tweet_storage
      # TODO: DirectMessage の場合を書く
    end
  end
end
