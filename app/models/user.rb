class User < ApplicationRecord
  validates :id_number, uniqueness: true
end
