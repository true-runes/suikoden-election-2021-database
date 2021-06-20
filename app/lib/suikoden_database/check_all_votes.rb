# rubocop:disable Rails/Output
module SuikodenDatabase
  class CheckAllVotes
    class << self
      def user_list_who_has_two_or_more_tweets
        users = users_has_two_or_more_tweets

        users.each do |user|
          puts "#{user.name} (@#{user.screen_name} / #{user.id_number})"
        end
      end

      def tweets_by_user_who_has_two_or_more_tweets(user)
        user.tweets
            .valid_term_votes
            .not_retweet
            .contains_hashtag('幻水総選挙2021')
            .not_by_gensosenkyo_main
            .order(tweeted_at: :asc)
            .order(id_number: :asc)
      end

      def users_has_two_or_more_tweets
        User.all.select do |user|
          user.tweets
              .valid_term_votes
              .not_retweet
              .contains_hashtag('幻水総選挙2021')
              .not_by_gensosenkyo_main
              .order(tweeted_at: :asc)
              .order(id_number: :asc)
              .count > 1
        end
      end
    end
  end
end
# rubocop:enable Rails/Output
