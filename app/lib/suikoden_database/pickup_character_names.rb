module SuikodenDatabase
  class PickupCharacterNames
    class << self
      def execute(tweet_or_dm)
        # FIXME: tweet_or_dm.analyze_syntax が nil の場合がある
        # おそらく DM は別タイミングで取得しているから、DM の analyze_syntax が存在しないときだろう
        check_words = tweet_or_dm.analyze_syntax&.check_words

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
      # ここでは、「check_wordsに現れている語の中で除外する語」を指定する
      # そもそも check_words に含まれていない語はここではどうしようもない
      def skip_words # rubocop:disable Metrics/MethodLength
        [
          'a',
          'b',
          'c',
          'd',
          'e',
          'f',
          'g',
          'h',
          'i',
          'j',
          'k',
          'l',
          'm',
          'n',
          'o',
          'p',
          'q',
          'r',
          's',
          't',
          'u',
          'v',
          'w',
          'x',
          'y',
          'z',
          'A',
          'B',
          'C',
          'D',
          'E',
          'F',
          'G',
          'H',
          'I',
          'J',
          'K',
          'L',
          'M',
          'N',
          'O',
          'P',
          'Q',
          'R',
          'S',
          'T',
          'U',
          'V',
          'W',
          'X',
          'Y',
          'Z',
          "cE",
          "Dp",
          'ほら',
          '次',
          '砦',
          'する',
          '心',
          'なっ',
          'たら',
          'おれ',
          'だ',
          'さま',
          'u',
          '英',
          '語',
          '版',
          'だ',
          'いう',
          'い',
          '∶',
          '/cI',
          'u',
          ':/',
          'me',
          'at',
          '船',
          '者',
          'い',
          'さま',
          '子',
          'お',
          '題',
          '話',
          'だ',
          '枚',
          'ます',
          't',
          'なっ',
          'た',
          '時',
          '元',
          '軍',
          'いる',
          '話',
          'だ',
          '題',
          'する',
          '時',
          'なぁ',
          'まし',
          'た',
          'ます',
          'お',
          ':/',
          'z',
          '63z',
          'さ',
          'せ',
          'たい',
          '話',
          'OT',
          'y',
          '事',
          '軍',
          '料',
          '理',
          '長',
          '小',
          '人',
          '公',
          '人公',
          '様',
          '票',
          '/',
          'm',
          '(',
          ')',
          '_',
          '__',
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
          '総',
          '選',
          '挙',
          '選挙',
          '幻水',
          'バー',
          'ッ',
        ].uniq
      end
    end
  end
end
