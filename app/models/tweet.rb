class Tweet < ApplicationRecord
  has_paper_trail

  belongs_to :user

  has_many :assets
  has_many :hashtags
  has_many :urls

  validates :id_number, uniqueness: true

  # TODO: TweetStorage の方にも書く
  def self.filter_tweeted_at(from, to)
    where('tweeted_at > ?', from).where('tweeted_at < ?', to)
  end

  def public?
    is_public
  end

  def source_app_name
    source
  end

  def in_reply_to_tweet
    Tweet.find_by(id_number: in_reply_to_tweet_id_number)
  end

  def in_reply_to_user
    User.find_by(id_number: in_reply_to_user_id_number)
  end

  def retweet?
    is_retweet
  end
end
