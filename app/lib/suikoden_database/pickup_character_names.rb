module SuikodenDatabase
  class PickupCharacterNames
    class << self
      def execute(tweet_or_dm)
        check_words = tweet_or_dm.analyze_syntax.check_words

        gensosenkyo_candidate_names = []
        check_words.each do |check_word|
          next if skip_word?(check_word)

          # 部分一致の場合
          result_gensosenkyo_names = Character.joins(:nicknames).where('nicknames.name LIKE ?', "%#{check_word}%").map(&:name).uniq

          # 完全一致の場合
          # result_gensosenkyo_names = Character.includes(:nicknames).where(nicknames: { name: check_word }).map(&:name).uniq

          gensosenkyo_candidate_names += result_gensosenkyo_names
        end

        gensosenkyo_candidate_names.uniq
      end

      def skip_word?(word)
        return true if word.in?(skip_words)

        false
      end

      # check_words の中身を連続で見ていった際に、これらの語の場合はキャラ名サーチをしない
      def skip_words
        [
          '一',
          'な',
          'る',
          'なる',
          '王',
          '異',
          '世',
          '界',
          '世界',
          'ち',
          'ゃ',
          'ん',
          'な',
          'る',
          'が',
          'れ',
          'し',
          '百',
          '年',
          'の',
          '時',
          'い',
          '（',
          '）',
          '幻',
          '水',
          '幻水',
          'バー',
          'ッ',
        ]
      end
    end
  end
end