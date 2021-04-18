class User < ApplicationRecord
  has_many :tweets, dependent: :destroy

  validates :id_number, uniqueness: true
end
