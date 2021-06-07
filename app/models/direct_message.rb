class DirectMessage < ApplicationRecord
  has_paper_trail

  serialize :api_response, JSON
  belongs_to :user

  validates :id_number, uniqueness: true

  # self.user と同義
  def sender
    User.find_by(id_number: sender_id_number)
  end

  def recipient
    User.find_by(id_number: recipient_id_number)
  end
end
