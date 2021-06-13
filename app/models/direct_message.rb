class DirectMessage < ApplicationRecord
  has_paper_trail

  serialize :api_response, JSON
  belongs_to :user
  has_one :analyze_syntax

  validates :id_number, uniqueness: true

  # self.user と同義
  def sender
    User.find_by(id_number: sender_id_number)
  end

  def recipient
    User.find_by(id_number: recipient_id_number)
  end

  def self.valid_term_votes
    begin_datetime = Time.zone.parse('2021-06-11 21:00:00')
    end_datetime = Time.zone.parse('2021-06-13 11:59:59')

    where(messaged_at: begin_datetime..end_datetime)
  end

  def self.extend_valid_term_votes
    begin_datetime = Time.zone.parse('2021-06-11 21:00:00')
    end_datetime = Time.zone.parse('2021-06-13 12:59:59')

    where(messaged_at: begin_datetime..end_datetime)
  end

  def self.only_beginning_valid_term_votes
    begin_datetime = Time.zone.parse('2021-06-11 21:00:00')

    where(messaged_at: begin_datetime..)
  end

  # gensosenkyo: 1471724029,
  # sub_gensosenkyo: 1388758231825018881
  def self.from_gensosenkyo_main
    where(sender_id_number: 1471724029)
  end

  def self.to_gensosenkyo_main
    where(recipient_id_number: 1471724029)
  end
end
