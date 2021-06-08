class Character < ApplicationRecord
  has_many :character_products, dependent: :destroy
  has_many :products, through: :character_products

  has_many :character_nicknames, dependent: :destroy
  has_many :nicknames, through: :character_nicknames
end
