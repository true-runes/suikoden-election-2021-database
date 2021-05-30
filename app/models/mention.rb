class Mention < ApplicationRecord
  belongs_to :tweet

  validates :user_id_number, uniqueness: { scope: [:tweet_id]  }

  def user
    User.find_by(id_number: user_id_number)
  end
end
