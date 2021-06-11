# TODO: データカテゴリごとにクラスを作るべき（特に DM の場合）

module GoogleSheetApi
  class WriteToTalliedSheet
    include LoggerMethods

    def initialize(spreadsheet_id: nil, sheet_name: nil)
      @client = GoogleSheetApi::Client.new.create
      @spreadsheet_id = spreadsheet_id || ENV['TALLIED_WORKSHEET_ID']
      @sheet_name = sheet_name || ENV['TALLIED_SHEET_NAME']
      # セル数が上限の 5,000,000 以下で、シート全部がカバーできるであろう範囲（A1形式しか指定できないのでこういう方法しかないと思う）
      @range = "#{@sheet_name}!A1:AD10000"
    end

    def execute(category: nil)
      permitted_category_names = [
        '公開ツイート',
        'お題小説',
        '推し台詞',
        'DM',
      ]

      return unless category.in?(permitted_category_names)

      case category
      when '公開ツイート'
        nagashikomi(category, in_public_timeline_tweets, sheets_in_public_timeline_tweets)
      when 'お題小説'
        nagashikomi(category, odai_shosetsu_tweets, sheets_odai_shosetsu_tweets)
      when '推し台詞'
        nagashikomi(category, oshi_serifu_tweets, sheets_oshi_serifu_tweets)
      when 'DM'
        nagashikomi(category, filtered_direct_messaages, sheets_for_filtered_direct_messaages)
      end
    end

    def nagashikomi(category, tweets_or_dms, target_sheets)
      i = 0

      tweets_or_dms.each_slice(100) do |sliced_tweets|
        target_sheet_name = target_sheets[i]

        # 書き込むデータを製造する
        inserted_100_rows = [] # Array in Array で行列データを表現する
        inserted_100_rows << [] # ヘッダ行は更新しない
        sliced_tweets.each do |tweet_or_dm|
          # 分岐が雑だが、#execute の方で category の内容が担保されているのでひとまずこれで
          if category == 'DM'
            @spreadsheet_id = ENV['TALLIED_DIRECT_MESSAGES_WORKSHEET_ID']
            inserted_100_rows << row_data_for_dm(tweet_or_dm)
          else
            @spreadsheet_id = ENV['TALLIED_WORKSHEET_ID']
            inserted_100_rows << row_data_for_tweet(tweet_or_dm)
          end
        end

        value_range_object = Google::Apis::SheetsV4::ValueRange.new(
          values: inserted_100_rows
        )

        @client.update_spreadsheet_value(
          @spreadsheet_id,
          "#{target_sheet_name}!A1:AD10000",
          value_range_object,
          value_input_option: 'RAW'
        )

        i += 1
      end
    end

    def filtered_direct_messaages
      DirectMessage
        .valid_term_votes
        .to_gensosenkyo_main
        .order(messaged_at: :asc)
    end

    def character_names_for_dropdown(tweet)
      candidate_names = SuikodenDatabase::PickupCharacterNames.execute(tweet)

      candidate_names.join(',')
    end

    # Model 側に書いてもいい
    def in_public_timeline_tweets
      Tweet
        .valid_term_votes
        .not_retweet
        .contains_hashtag('幻水総選挙2021')
        .not_by_gensosenkyo_main
        .order(tweeted_at: :asc)
    end

    def odai_shosetsu_tweets
      Tweet
        .not_retweet
        .not_by_gensosenkyo_main
        .contains_hashtag('幻水総選挙お題小説')
        .where(tweeted_at: ..Time.zone.parse('2021-06-07 02:20:00'))
        .order(tweeted_at: :asc)
    end

    def oshi_serifu_tweets
      Tweet
        .not_retweet
        .not_by_gensosenkyo_main
        .contains_hashtag('幻水総選挙推し台詞')
        .where(tweeted_at: ..Time.zone.parse('2021-06-10 23:59:59'))
        .order(tweeted_at: :asc)
    end

    def row_data_for_tweet(tweet)
      [
        nil, # id
        tweet.url, # url
        tweet.full_text, # 内容
        nil, # キャラ1
        nil, # キャラ2
        nil, # キャラ3
        tweet.is_public?, # ツイートが見えるか？
        nil, # 備考
        nil, # 要レビュー？
        nil, # 二次チェック済み？
        nil, # 全チェック終了？
        character_names_for_dropdown(tweet), # ドロップダウン用のカンマ区切り文字列
        nil, # ここより右の列は任意項目
        nil, # 全振り？（全振りの場合はキャラクター名が入る。集計確定後に別途入れる）
        nil, # 登場作品 / ここは別の工程で入る（今の段階では断定できないため）
        tweet.language, # 言語
      ]
    end

    def row_data_for_dm(dm)
      [
        nil, # id
        dm.sender.name, # url の列だが、送信者の名前を入れる（よくない）
        dm.text, # 内容
        nil, # キャラ1
        nil, # キャラ2
        nil, # キャラ3
        true, # ツイートが見えるか？
        nil, # 備考
        nil, # 要レビュー？
        nil, # 二次チェック済み？
        nil, # 全チェック終了？
        character_names_for_dropdown(tweet), # ドロップダウン用のカンマ区切り文字列
        nil, # ここより右の列は任意項目
        nil, # 全振り？（全振りの場合はキャラクター名が入る。集計確定後に別途入れる）
        nil, # 登場作品 / ここは別の工程で入る（今の段階では断定できないため）
        nil, # 言語（DM の場合は手入力）
      ]
    end

    def sheets_in_public_timeline_tweets
      [
        'G_集計_00',
        'G_集計_01',
        'G_集計_02',
        'G_集計_03',
        'G_集計_04',
        'G_集計_05',
        'G_集計_06',
        'G_集計_07',
        'G_集計_08',
        'G_集計_09',
        'G_集計_10',
        'G_集計_11',
        'G_集計_12',
        'G_集計_13',
        'G_集計_14',
        'G_集計_15',
        'G_集計_16',
        'G_集計_17',
        'G_集計_18',
        'G_集計_19',
        'G_集計_20',
        'G_集計_21',
        'G_集計_22',
        'G_集計_23',
        'G_集計_24',
      ]
    end

    def sheets_odai_shosetsu_tweets
      [
        'S_お題小説_00',
        'S_お題小説_01',
      ]
    end

    def sheets_oshi_serifu_tweets
      [
        'T_推し台詞_00',
        'T_推し台詞_01',
        'T_推し台詞_02',
        'T_推し台詞_03',
        'T_推し台詞_04',
      ]
    end

    def sheets_for_filtered_direct_messaages
      [
        'K_集計_DM_00',
        'K_集計_DM_01',
        'K_集計_DM_02',
        'K_集計_DM_03',
        'K_集計_DM_04',
        'K_集計_DM_05',
        'K_集計_DM_06',
        'K_集計_DM_07',
        'K_集計_DM_08',
        'K_集計_DM_09',
      ]
    end
  end
end
