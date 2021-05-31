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
end
