class User < ApplicationRecord
  has_paper_trail

  has_many :tweets, dependent: :destroy
  has_many :direct_messages, dependent: :destroy

  validates :id_number, uniqueness: true

  scope :by_tweets, ->(target_tweets) { joins(:tweets).where(tweets: target_tweets) }

  def assets; end

  def protected?
    is_protected
  end

  def url
    "https://twitter.com/#{screen_name}"
  end

  def url_by_id_number_only
    "https://twitter.com/i/user/#{id_number}"
  end

  def gensosenkyo_admin?
    gensosenkyo_admin_user_id_numbers = {
      gensosenkyo: 1471724029,
      sub_gensosenkyo: 1388758231825018881
    }

    id_number.in?(gensosenkyo_admin_user_id_numbers.values)
  end

  def self.who_vote_two_or_more_without_not_public
    self.select { |user| user.tweets.gensosenkyo_2021_votes.is_public.count > 1 }
  end

  def self.did_vote_without_not_public
    self.select { |user| user.tweets.gensosenkyo_2021_votes.is_public.count > 0 }
  end
end
