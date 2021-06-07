namespace :insert_born_at_to_users do
  desc 'Insert "born_at" column data to User'
  task execute: :environment do
    ActiveRecord::Base.transaction do
      all_users = User.all

      all_users.each do |user|
        next if user.born_at.present?

        user_from_tweet_storage = UserFromTweetStorage.where(id_number: user.id_number).order(updated_at: :desc).first

        next if user_from_tweet_storage.blank?

        user.born_at = user_from_tweet_storage.created_at
        user.save!

        Rails.logger.info("insert_born_at_to_users:execute: '#{user.screen_name}' insert OK!")
      end
    end
  end
end
