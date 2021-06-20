module SuikodenDatabase
  class CheckVotes
    class << self
      def user_vs_number_of_votes_sorted_by_number_of_votes
        Hash[vote_two_or_more_user_vs_number_of_votes.sort_by { |_, v| -v }]
      end

      def vote_two_or_more_user_vs_number_of_votes
        vote_two_or_more_user_vs_number_of_votes = {}
        user_ids = User.who_vote_two_or_more_without_not_public.pluck(:id_number).uniq

        user_ids.each do |user_id|
          user = User.find_by(id_number: user_id)

          vote_two_or_more_user_vs_number_of_votes[user.id_number.to_s] = user.tweets.gensosenkyo_2021_votes.is_public.count
        end

        vote_two_or_more_user_vs_number_of_votes
      end

      def vote_user_vs_number_of_votes
        vote_user_vs_number_of_votes = {}
        user_ids = User.did_vote_without_not_public.pluck(:id_number).uniq

        user_ids.each do |user_id|
          user = User.find_by(id_number: user_id)

          vote_user_vs_number_of_votes[user.id_number.to_s] = user.tweets.gensosenkyo_2021_votes.is_public.count
        end

        vote_user_vs_number_of_votes
      end
    end
  end
end
