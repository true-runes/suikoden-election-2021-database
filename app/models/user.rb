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
end
