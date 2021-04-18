class BySearchWordTweet < TweetFromTweetStorage
  validates :search_word, presence: true
end
