class Hashtag < ApplicationRecord
  belongs_to :tweet

  def convert_to_search_word
    "##{text}"
  end
end
