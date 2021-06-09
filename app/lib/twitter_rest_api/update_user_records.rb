module TwitterRestApi
  class UpdateUserRecords
    include LoggerMethods

    INTERVAL_SECONDS = 5

    def initialize(consumer_key: nil, consumer_secret: nil, access_token: nil, access_secret: nil)
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = consumer_key || ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret     = consumer_secret || ENV['TWITTER_CONSUMER_SECRET']
        config.access_token        = access_token || ENV['TWITTER_ACCESS_TOKEN']
        config.access_token_secret = access_secret || ENV['TWITTER_ACCESS_SECRET']
      end
    end

    def execute
      set_not_public_user_objects_and_public_user_objects

      # ログ用
      changed_user_record_id_numbers = []

      # APIで持ってきた「今現在protectedなユーザー」のデータを、データベース上に格納されてい情報から持ってくる
      # そのデータにおいてユーザがpublicだった場合にのみ、データベース上のデータを更新する
      ActiveRecord::Base.transaction do
        User.where(id_number: @not_public_user_objects.map(&:id)).each do |user|
          unless user.protected?
            # Twitter のオブジェクト上の id という属性は、User のオブジェクト上の id_number という属性と等しい
            latest_user_on_twitter = @not_public_user_objects.find do |user_object|
              user_object.id == user.id_number
            end

            user.update!(
              name: latest_user_on_twitter.name.nil? ? '凍結中ユーザー' : latest_user_on_twitter.name,
              screen_name: latest_user_on_twitter.screen_name,
              profile_image_url_https: latest_user_on_twitter.profile_image_url.to_s,
              is_protected: latest_user_on_twitter.protected?,
              born_at: latest_user_on_twitter.created_at
            )

            changed_user_record_id_numbers << user.id_number
          end
        end
      end

      # APIで持ってきた「今現在publicなユーザー」のデータを、データベース上に格納されてい情報から持ってくる
      # そしてそのデータを更新する（スクリーンネームや名前の変更がありうるので、更新のための条件は設けない）
      ActiveRecord::Base.transaction do
        User.where(id_number: @public_user_objects.map(&:id)).each do |user|
          # Twitter のオブジェクト上の id という属性は、User のオブジェクト上の id_number という属性と等しい
          latest_user_on_twitter = @public_user_objects.find do |user_object|
            user_object.id == user.id_number
          end

          user.update!(
            name: latest_user_on_twitter.name.nil? ? '凍結中ユーザー' : latest_user_on_twitter.name,
            screen_name: latest_user_on_twitter.screen_name,
            profile_image_url_https: latest_user_on_twitter.profile_image_url.to_s,
            is_protected: latest_user_on_twitter.protected?,
            born_at: latest_user_on_twitter.created_at
          )

          changed_user_record_id_numbers << user.id_number
        end
      end

      logger_options = {
        message: 'User の protected 状態の変更',
        tweets: changed_user_record_id_numbers
      }
      Rails.logger.info(LoggerMethods.convert_hash_to_json(logger_options))
    end

    # https://developer.twitter.com/en/docs/twitter-api/v1/accounts-and-users/follow-search-get-users/api-reference/get-users-lookup
    # Returns fully-hydrated user objects for up to 100 users per reques
    # Requests / 15-min window (app auth): 300 #=> 1分に20回まで
    def set_not_public_user_objects_and_public_user_objects
      not_public_user_objects = []
      public_user_objects = []

      User.order(created_at: :asc).pluck(:id_number).each_slice(100) do |sliced_all_id_numbers|
        sliced_id_numbers_users = @client.users(sliced_all_id_numbers)

        sliced_id_numbers_users.each do |user|
          # Twitter::User の方の protected? メソッドである
          if user.protected?
            not_public_user_objects << user
          else
            public_user_objects << user
          end
        end

        sleep INTERVAL_SECONDS
      end

      @not_public_user_objects = not_public_user_objects
      @public_user_objects = public_user_objects
    end
  end
end
