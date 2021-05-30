class Url < ApplicationRecord
  belongs_to :tweet

  validates :text, uniqueness: { scope: [:tweet_id]  }
end
