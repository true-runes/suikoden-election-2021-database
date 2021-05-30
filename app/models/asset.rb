class Asset < ApplicationRecord
  has_paper_trail

  belongs_to :tweet
end
