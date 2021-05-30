class Url < ApplicationRecord
  belongs_to :tweet

  validates :text, uniqueness: true
end
