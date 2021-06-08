class CharacterProduct < ApplicationRecord
  belongs_to :character
  belongs_to :product
end
