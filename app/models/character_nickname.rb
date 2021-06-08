class CharacterNickname < ApplicationRecord
  belongs_to :character
  belongs_to :nickname
end
