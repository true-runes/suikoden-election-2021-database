module TwitterRestApi
  class DirectMessageImporter
    include LoggerMethods

    INTERVAL_SECONDS = 65

    def initialize(consumer_key: nil, consumer_secret: nil, access_token: nil, access_secret: nil)
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = consumer_key || ENV.fetch('TWITTER_CONSUMER_KEY', nil)
        config.consumer_secret     = consumer_secret || ENV.fetch('TWITTER_CONSUMER_SECRET', nil)
        config.access_token        = access_token || ENV.fetch('TWITTER_ACCESS_TOKEN', nil)
        config.access_token_secret = access_secret || ENV.fetch('TWITTER_ACCESS_SECRET', nil)
      end
    end

    # Ruby っぽくない
    def execute(get_all_messages: false)
      next_cursor = nil
      end_of_while = false

      # rubocop:disable Style/InfiniteLoop
      while true
        # rubocop:disable Style/ConditionalAssignment
        if next_cursor.nil?
          dm_events = @client.direct_messages_events(count: 1)
        else
          dm_events = @client.direct_messages_events(count: 1, cursor: next_cursor)
        end
        # rubocop:enable Style/ConditionalAssignment

        dm_events = dm_events.to_h
        next_cursor = dm_events[:next_cursor]
        events = dm_events[:events]

        ActiveRecord::Base.transaction do
          events.each do |event|
            # events という配列が常に新しい順から並んでいることを前提としている
            if DirectMessage.find_by(id_number: event[:direct_message][:id]).present? && get_all_messages != true
              end_of_while = true

              break
            end

            [event[:direct_message][:sender_id], event[:direct_message][:recipient_id]].each do |user_id_number|
              if User.find_by(id_number: user_id_number).blank?
                target_user = @client.user(user_id_number)

                user = User.new(
                  id_number: user_id_number,
                  name: target_user.name,
                  screen_name: target_user.screen_name,
                  profile_image_url_https: target_user.profile_image_url_https.to_s,
                  is_protected: target_user.protected?,
                  born_at: target_user.created_at
                )
                user.save!
              end
            end

            direct_message = DirectMessage.new(
              id_number: event[:direct_message][:id],
              messaged_at: event[:direct_message][:created_at],
              text: event[:direct_message][:text],
              sender_id_number: event[:direct_message][:sender_id],
              recipient_id_number: event[:direct_message][:recipient_id],
              is_visible: true,
              user_id: User.find_by(id_number: event[:direct_message][:sender_id]).id,
              api_response: event
            )
            direct_message.save! if DirectMessage.find_by(id_number: event[:direct_message][:id]).blank?
          end
        end
        # rubocop:enable Style/InfiniteLoop

        break if next_cursor.nil?
        break if end_of_while == true

        Rails.logger.info("TwitterRestApi::DirectMessageImporter#execute: next_cursor (#{next_cursor}), events.count (#{events.count})")

        sleep INTERVAL_SECONDS
      end
    end
  end
end
