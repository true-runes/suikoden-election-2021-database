class DirectMessage < ApplicationRecord
  has_paper_trail

  belongs_to :user

  validates :id_number, uniqueness: true

  def sender
    User.find_by(id: sender_id_number)
  end

  def recipient
    User.find_by(id: recipient_id_number)
  end
end
