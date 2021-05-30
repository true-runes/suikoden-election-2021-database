class Url < ApplicationRecord
  belongs_to :tweet

  validates :text, uniquness: { scope: [:tweet_id]  }
end
