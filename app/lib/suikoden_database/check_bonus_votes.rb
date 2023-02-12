# rubocop:disable Style/HashConversion
module SuikodenDatabase
  class CheckBonusVotes
    class << self
      def odai_shosetsu_user_vs_number_of_posts_sorted_by_number_of_posts
        Hash[odai_shosetsu_user_vs_number_of_posts.sort_by { |_, v| -v }]
      end

      # odai_shosetsu_user_vs_number_of_posts.keys.count: 総投稿人数
      # odai_shosetsu_user_vs_number_of_posts.values.sum: 総投稿数
      def odai_shosetsu_user_vs_number_of_posts
        odai_shosetsu_user_vs_number_of_posts = {}
        user_ids = users_who_posted_odai_shosetsu.pluck(:id_number).uniq

        user_ids.each do |user_id|
          user = User.find_by(id_number: user_id)

          odai_shosetsu_user_vs_number_of_posts[user.id_number.to_s] = user.tweets.odai_shosetsu.is_public.count
        end

        odai_shosetsu_user_vs_number_of_posts
      end

      def users_who_posted_odai_shosetsu
        User.all.select { |user| user.tweets.odai_shosetsu.is_public.count > 0 }
      end

      def oshi_serifu_user_vs_number_of_posts_sorted_by_number_of_posts
        Hash[oshi_serifu_user_vs_number_of_posts.sort_by { |_, v| -v }]
      end

      # oshi_serifu_user_vs_number_of_posts.keys.count: 総投稿人数
      # oshi_serifu_user_vs_number_of_posts.values.sum: 総投稿数
      def oshi_serifu_user_vs_number_of_posts
        oshi_serifu_user_vs_number_of_posts = {}
        user_ids = users_who_posted_oshi_serifu.pluck(:id_number).uniq

        user_ids.each do |user_id|
          user = User.find_by(id_number: user_id)

          oshi_serifu_user_vs_number_of_posts[user.id_number.to_s] = user.tweets.oshi_serifu.is_public.count
        end

        oshi_serifu_user_vs_number_of_posts
      end

      def users_who_posted_oshi_serifu
        User.all.select { |user| user.tweets.oshi_serifu.is_public.count > 0 }
      end
    end
  end
end
# rubocop:enable Style/HashConversion
