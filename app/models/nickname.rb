class Nickname < ApplicationRecord
  has_many :character_nicknames, dependent: :destroy
  has_many :characters, through: :character_nicknames
end
