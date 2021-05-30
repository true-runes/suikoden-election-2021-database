class Hashtag < ApplicationRecord
  belongs_to :tweet

  validates :text, uniqueness: { scope: [:tweet_id]  }

  # TODO: テスト書く
  def has_this_hashtag?(hashtag)
    hashtags.any? { |h| h == hashtag }
  end

  def has_assets?
    assets.present?
  end

  def has_urls?
    urls.present?
  end
end
