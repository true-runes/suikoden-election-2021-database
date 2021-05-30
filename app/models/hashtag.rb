class Hashtag < ApplicationRecord
  belongs_to :tweet

  def has_assets?
    assets.present?
  end

  def has_urls?
    urls.present?
  end
end
