module TwitterRestApi
  class CheckProtectedUsers
    include LoggerMethods

    INTERVAL_SECONDS = 5

    def initialize(consumer_key=nil, consumer_secret=nil, access_token=nil, access_secret=nil)
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = consumer_key || ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret     = consumer_secret || ENV['TWITTER_CONSUMER_SECRET']
        config.access_token        = access_token || ENV['TWITTER_ACCESS_TOKEN']
        config.access_token_secret = access_secret || ENV['TWITTER_ACCESS_SECRET']
      end
    end

    def update_all_user_is_protected_statuses
      set_not_public_user_id_numbers_and_public_user_id_numbers

      # ログ用
      changed_status_user_id_numbers = []

      # 公開アカ -> 鍵アカ or アカ削除
      ActiveRecord::Base.transaction do
        User.where(id_number: @not_public_user_id_numbers).each do |user|
          unless user.protected?
            user.update!(is_protected: true)

            changed_status_user_id_numbers << user.id_number
          end
        end
      end

      # 鍵アカ -> 公開アカ
      ActiveRecord::Base.transaction do
        Tweet.where(id_number: @public_user_id_numbers).each do |user|
          if user.protected?
            user.update!(is_protected: false)

            changed_status_user_id_numbers << user.id_number
          end
        end
      end

      logger_options = {
        message: 'User の protected 状態の変更',
        tweets: changed_status_user_id_numbers
      }
      Rails.logger.info(LoggerMethods.convert_hash_to_json(logger_options))
    end

    # https://developer.twitter.com/en/docs/twitter-api/v1/accounts-and-users/follow-search-get-users/api-reference/get-users-lookup
    # Returns fully-hydrated user objects for up to 100 users per reques
    # Requests / 15-min window (app auth): 300 #=> 1分に20回まで
    def set_not_public_user_id_numbers_and_public_user_id_numbers
      not_public_user_id_numbers = []
      public_user_id_numbers = []

      User.order(created_at: :asc).pluck(:id_number).each_slice(100) do |sliced_all_id_numbers|
        sliced_id_numbers_users = @client.users(sliced_all_id_numbers)

        sliced_id_numbers_users.each do |user|
          # Twitter::User の方の protected? メソッドである
          if user.protected?
            not_public_user_id_numbers << user.id
          else
            public_user_id_numbers << user.id
          end
        end

        sleep INTERVAL_SECONDS
      end

      @not_public_user_id_numbers = not_public_user_id_numbers
      @public_user_id_numbers = public_user_id_numbers
    end
  end
end
