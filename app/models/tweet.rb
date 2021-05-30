class Tweet < ApplicationRecord
  has_paper_trail

  belongs_to :user

  has_many :assets
  has_many :hashtags
  has_many :urls

  validates :id_number, uniqueness: true

  def public?
    is_public
  end

  def source_app_name
    source
  end
end
