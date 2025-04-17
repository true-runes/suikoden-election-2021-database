class Selector
  class << self
    # 対象を絞って高速化する
    # 'hashtag' には '#' は不要
    def excluded_already_existing_tweets_by_hashtag_from_tweet_storage(hashtag)
      BySearchWordTweet.where(
        search_word: "##{hashtag}"
      ).where.not(
        id_number: Tweet.contains_hashtag(hashtag).select(:id_number)
      )
    end
  end
end
