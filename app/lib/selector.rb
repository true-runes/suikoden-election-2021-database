class Selector
  class << self
    def newer_tweets_by_hashtag_search_from_tweet_storage(hashtag)
      maximum_tweet_id_number = Tweet.with_hashtag(hashtag).maximum(:id_number)

      BySearchWordTweet.where(search_word: "##{hashtag}").where('id_number > ?', maximum_tweet_id_number)
    end
  end
end
