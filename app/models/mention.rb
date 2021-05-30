class Mention < ApplicationRecord
  belongs_to :tweet

  def user
    User.find_by(id_number: user_id_number)
  end
end
