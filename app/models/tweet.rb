class Tweet < ApplicationRecord
  has_paper_trail

  belongs_to :user
  has_many :assets
  has_many :hashtags
  has_many :in_tweet_urls
  has_many :mentions

  validates :id_number, uniqueness: true

  scope :not_retweet, -> { where(is_retweet: false) }
  scope :be_retweet, -> { where(is_retweet: true) }
  scope :with_hashtag, ->(hashtag) { joins(:hashtags).where(hashtags: { text: hashtag }) }
  scope :mentioned_user, ->(user) { joins(:mentions).where(mentions: { user_id_number: user.id_number }) }

  # TODO: TweetStorage の方にも書く
  def self.filter_by_tweeted_at(from, to)
    where(tweeted_at: from..to)
  end

  def self.valid_votes
    begin_datetime = Time.zone.parse('2021-06-11 21:00:00')
    end_datetime = Time.zone.parse('2021-06-13 11:59:59')

    where(tweeted_at: begin_datetime..end_datetime)
  end

  def has_this_hashtag?(hashtag)
    hashtags.any? { |h| h.text == hashtag }
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

  def url
    "https://twitter.com/#{user.screen_name}/status/#{id_number}"
  end

  def url_by_id_number_only
    "https://twitter.com/twitter/status/#{id_number}"
  end

  def has_hashtags?
    hashtags.present?
  end

  def has_assets?
    assets.present?
  end

  def has_in_tweet_urls?
    in_tweet_urls.present?
  end
end
