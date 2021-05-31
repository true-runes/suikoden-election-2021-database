# コンストラクタで指定シートの既存情報を取得し（いきなり API が走る）、
# ローカルのデータベースから挿入対象データを抽出し、
# 既存情報の後ろに挿入対象データを加えたデータを作成し、
# そのデータをスプレッドシートに書き込む。

module GoogleSheetApi
  class WriteToResponseApiSheetByHashtag
    def initialize(spreadsheet_id: nil, sheet_name: nil)
      @client = GoogleSheetApi::Client.new.create
      @spreadsheet_id = spreadsheet_id || ENV['RECOMMENDED_QUOTES_WORKSHEET_ID']
      @sheet_name = sheet_name || ENV['RECOMMENDED_QUOTES_SHEET_NAME']
      # セル数が上限の 5,000,000 以下で、シート全部がカバーできるであろう範囲（A1形式しか指定できないのでこういう方法しかないと思う）
      @range = "#{@sheet_name}!A1:AD10000"

      set_basic_valiables
    end

    def execute(hashtag)
      update_data(target_tweets(hashtag))
    end

    # 既存のデータを読み込み、新規のデータをその後ろにくっつけ、それを貼り付けている
    def update_data(tweets)
      updated_values = []

      @already_sheet_all_data.each { |v| updated_values << v }
      # id列 に入る番号は (行数 - 1) だから、@number_of_already_existing_rows の値をそのまま入れれば良い
      all_append_rows = all_append_rows(tweets, @number_of_already_existing_rows)
      all_append_rows.each { |v| updated_values << v }

      value_range_object = Google::Apis::SheetsV4::ValueRange.new(values: updated_values)

      @client.update_spreadsheet_value(
        @spreadsheet_id,
        @range,
        value_range_object,
        value_input_option: 'RAW'
      )
    end

    def target_tweets(hashtag)
      # 初回操作対応
      beginning_search_tweet_id_number = @max_tweet_id_number.present? ? @max_tweet_id_number + 1 : 1

      Tweet.not_retweet.contains_hashtag(hashtag).not_by_gensosenkyo.where(
        id_number: beginning_search_tweet_id_number..
      ).where(
        tweeted_at: Time.zone.parse('2021-05-01')..
      ).order(tweeted_at: :asc)
    end

    def set_basic_valiables
      already_sheet_all_data = @client.get_spreadsheet_values(
        @spreadsheet_id,
        @range
      )

      # rubocop:disable Style/HashEachMethods
      max_number_of_columns = 0
      already_sheet_all_data.values.each { |row| max_number_of_columns = row.count if row.count > max_number_of_columns }
      @number_of_already_existing_rows = already_sheet_all_data.values.count
      @number_of_already_existing_columns = max_number_of_columns
      # rubocop:enable Style/HashEachMethods

      @already_sheet_all_data = cast_value_type(already_sheet_all_data.values)
      set_max_tweet_id_number(already_sheet_all_data) # @max_tweet_id_number
    end

    # スプレッドシートから取得したデータは型を適切に変換しないと、書き込む時に全て文字列になってしまう
    def cast_value_type(already_sheet_all_data_values)
      casted_already_sheet_all_data = []

      already_sheet_all_data_values.each.with_index do |row, row_number|
        # ヘッダはそのまま
        if row_number == 0
          casted_already_sheet_all_data << row

          next
        end

        # rubocop:disable Style/Semicolon
        inserted_row = []
        row.each.with_index do |cell, column_number|
          if column_number.in?([0])
            inserted_row << cell.to_i; next
          end

          if cell == 'FALSE' && column_number.in?([5, 8, 9, 10])
            inserted_row << false; next
          end

          if cell == 'TRUE' && column_number.in?([5, 8, 9, 10])
            inserted_row << true; next
          end

          inserted_row << cell
        end
        # rubocop:enable Style/Semicolon

        casted_already_sheet_all_data << inserted_row
      end

      casted_already_sheet_all_data
    end

    def set_max_tweet_id_number(already_sheet_data)
      tweet_id_numbers = already_sheet_data.values.map do |row|
        next if row[1] == 'tweetId'

        row[1].delete(',').to_i
      end

      tweet_id_numbers.compact!
      @max_tweet_id_number = tweet_id_numbers.max
    end

    def all_append_rows(tweets, begin_index_number)
      all_append_rows = []

      tweets.each.with_index(begin_index_number) do |tweet, index|
        all_append_rows << row_value(tweet, index)
      end

      all_append_rows
    end

    private

    def row_value(tweet, index)
      [
        index.to_i,
        tweet_id_column_value(tweet).to_s, # 数値のままだと最初の数桁が全部 '0' になってしまう
        username_column_value(tweet),
        screen_name_column_value(tweet),
        full_text_column_value(tweet),
        is_retweet_column_value(tweet),
        url_column_value(tweet),
        tweeted_at_column_value(tweet),
        media_exists_column_value(tweet),
        is_public_column_value(tweet),
        is_mentioned_to_gensosenkyo_admin(tweet),
      ]
    end

    def id_column_value(tweet)
      tweet.id_number
    end

    def tweet_id_column_value(tweet)
      tweet.id_number
    end

    def username_column_value(tweet)
      tweet.user.name
    end

    def screen_name_column_value(tweet)
      tweet.user.screen_name
    end

    def full_text_column_value(tweet)
      tweet.full_text
    end

    def is_retweet_column_value(tweet)
      tweet.retweet?
    end

    def url_column_value(tweet)
      tweet.url
    end

    def tweeted_at_column_value(tweet)
      convert_datetime_to_jp_style(tweet.tweeted_at)
    end

    def convert_datetime_to_jp_style(datetime)
      wdays = ['日', '月', '火', '水', '木', '金', '土']

      datetime.strftime("%Y/%m/%d(#{wdays[datetime.wday]}) %H:%M:%S")
    end

    def media_exists_column_value(tweet)
      tweet.has_assets?
    end

    def is_public_column_value(tweet)
      tweet.is_public?
    end

    def is_mentioned_to_gensosenkyo_admin(tweet)
      # gensosenkyo: 1471724029, sub_gensosenkyo: 1388758231825018881
      gensosenkyo_admin_user_id_numbers = {
        'gensosenkyo': 1471724029,
        'sub_gensosenkyo': 1388758231825018881
      }

      tweet.mentions.any? { |mention| mention.user_id_number.in?(gensosenkyo_admin_user_id_numbers.values) }
    end

    def headers
      %w(
        id tweetId username screenName fullText isRetweet
        url tweetedAt mediaExists isPublic isMentionedToGssAdmin
      )
    end

    # 使う機会ないかも
    def convert_column_alphabet_to_column_id(alphabet)
      {
        A => 1,
        B => 2,
        C => 3,
        D => 4,
        E => 5,
        F => 6,
        G => 7,
        H => 8,
        I => 9,
        J => 10,
        K => 11,
        L => 12,
        M => 13,
        N => 14,
        O => 15,
        P => 16,
        Q => 17,
        R => 18,
        S => 19,
        T => 20,
        U => 21,
        V => 22,
        W => 23,
        X => 24,
        Y => 25,
        Z => 26,
        AA => 27,
        AB => 28,
        AC => 29,
        AD => 30,
        AE => 31,
        AF => 32,
        AG => 33
      }[alphabet]
    end

    # 使う機会ないかも
    def convert_column_id_to_column_alphabet(column_id)
      {
        '1' => A,
        '2' => B,
        '3' => C,
        '4' => D,
        '5' => E,
        '6' => F,
        '7' => G,
        '8' => H,
        '9' => I,
        '10' => J,
        '11' => K,
        '12' => L,
        '13' => M,
        '14' => N,
        '15' => O,
        '16' => P,
        '17' => Q,
        '18' => R,
        '19' => S,
        '20' => T,
        '21' => U,
        '22' => V,
        '23' => W,
        '24' => X,
        '25' => Y,
        '26' => Z,
        '27' => AA,
        '28' => AB,
        '29' => AC,
        '30' => AD,
        '31' => AE,
        '32' => AF,
        '33' => AG
      }[column_id.to_s]
    end
  end
end
