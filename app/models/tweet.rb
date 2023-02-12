class Tweet < ApplicationRecord
  has_paper_trail

  has_one :analyze_syntax
  belongs_to :user
  has_many :assets
  has_many :hashtags
  has_many :in_tweet_urls
  has_many :mentions

  validates :id_number, uniqueness: true

  scope :not_retweet, -> { where(is_retweet: false) }
  scope :be_retweet, -> { where(is_retweet: true) }
  scope :contains_hashtag, ->(hashtag) { joins(:hashtags).where(hashtags: { text: hashtag }) }
  scope :mentioned_user, ->(user) { joins(:mentions).where(mentions: { user_id_number: user.id_number }) }
  scope :is_public, -> { where(is_public: true) }

  # TODO: TweetStorage の方にも書く
  def self.filter_by_tweeted_at(from, to)
    where(tweeted_at: from..to)
  end

  def self.gensosenkyo_2021_votes
    valid_term_votes
      .not_retweet
      .contains_hashtag('幻水総選挙2021')
      .not_by_gensosenkyo_main
      .order(tweeted_at: :asc)
      .order(id_number: :asc)
  end

  def self.not_by_gensosenkyo_family
    # gensosenkyo: 1471724029,
    # sub_gensosenkyo: 1388758231825018881

    target_user_ids = [
      User.find_by(id_number: 1471724029)&.id,
      User.find_by(id_number: 1388758231825018881)&.id,
    ].compact

    where.not(user_id: target_user_ids)
  end

  def self.not_by_gensosenkyo_main
    target_user_ids = [
      User.find_by(id_number: 1471724029)&.id,
    ].compact

    where.not(user_id: target_user_ids)
  end

  def self.not_by_gensosenkyo_sub
    target_user_ids = [
      User.find_by(id_number: 1388758231825018881)&.id,
    ].compact

    where.not(user_id: target_user_ids)
  end

  def self.valid_term_votes
    begin_datetime = Time.zone.parse('2021-06-11 21:00:00')
    end_datetime = Time.zone.parse('2021-06-13 11:59:59')

    where(tweeted_at: begin_datetime..end_datetime)
  end

  def self.odai_shosetsu
    not_retweet
      .not_by_gensosenkyo_main
      .contains_hashtag('幻水総選挙お題小説')
      .where(tweeted_at: ..Time.zone.parse('2021-06-07 02:20:00'))
      .order(tweeted_at: :asc)
      .order(id_number: :asc)
  end

  def self.oshi_serifu
    not_retweet
      .not_by_gensosenkyo_main
      .contains_hashtag('幻水総選挙推し台詞')
      .where(tweeted_at: ..Time.zone.parse('2021-06-10 23:59:59'))
      .order(tweeted_at: :asc)
      .order(id_number: :asc)
  end

  def valid_term_vote?
    begin_datetime = Time.zone.parse('2021-06-11 21:00:00')
    end_datetime = Time.zone.parse('2021-06-13 11:59:59')

    tweeted_at >= begin_datetime && tweeted_at <= end_datetime
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

  def is_mentioned_to_gensosenkyo_admin?
    # gensosenkyo: 1471724029, sub_gensosenkyo: 1388758231825018881
    gensosenkyo_admin_user_id_numbers = {
      gensosenkyo: 1471724029,
      sub_gensosenkyo: 1388758231825018881
    }

    mentions.any? { |mention| mention.user_id_number.in?(gensosenkyo_admin_user_id_numbers.values) }
  end
end
