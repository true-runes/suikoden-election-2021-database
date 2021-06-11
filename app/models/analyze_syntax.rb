require 'nkf'

class AnalyzeSyntax < ApplicationRecord
  belongs_to :tweet, optional: true
  belongs_to :direct_message, optional: true

  def convert_analyze_syntax_response_sentence_objects
    hashed_sentences.map do |hashed_sentence|
      hashed_sentence.merge!(analyze_syntax_id: id)

      AnalyzeSyntaxResponse::Sentence.new(hashed_sentence)
    end
  end

  def convert_analyze_syntax_response_token_objects
    hashed_tokens.map do |hashed_token|
      hashed_token.merge!(analyze_syntax_id: id)

      AnalyzeSyntaxResponse::Token.new(hashed_token)
    end
  end

  def hashed_tokens
    tokens.map { |token| JSON.parse(token) }
  end

  def hashed_sentences
    sentences.map { |sentence| JSON.parse(sentence) }
  end

  # rubocop:disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
  # 完全一致でキャラ名一覧と比較するので、最大限に広く word を持つようにしている
  def check_words
    # TODO: 検知できていない単語例
    # 「主人公」（単体で現れると前後関係や他の単語と併せて検討する必要がある）
    (
      words_with_noun_and_punct_and_noun_tags +
      words_with_noun_and_punct_and_noun_tags.map { |word| remove_all_three_point_readers_from_word(word) } +
      words_with_noun_and_punct_and_noun_tags.map { |word| convert_hankaku_katakana_to_zenkaku_katakana(word) } +
      words_with_noun_and_punct_and_noun_tags.map { |word| convert_zenkaku_numbers_to_hankaku_numbers(word) } +
      words_with_basic_filters +
      words_with_basic_filters.map { |word| remove_all_three_point_readers_from_word(word) } +
      words_with_basic_filters.map { |word| convert_hankaku_katakana_to_zenkaku_katakana(word) } +
      words_with_basic_filters.map { |word| convert_zenkaku_numbers_to_hankaku_numbers(word) } +
      words_with_noun_and_affix_tags +
      words_with_noun_and_affix_tags.map { |word| remove_all_three_point_readers_from_word(word) } +
      words_with_noun_and_affix_tags.map { |word| convert_hankaku_katakana_to_zenkaku_katakana(word) } +
      words_with_noun_and_affix_tags.map { |word| convert_zenkaku_numbers_to_hankaku_numbers(word) } +
      words_with_num_and_affix_tags +
      words_with_num_and_affix_tags.map { |word| remove_all_three_point_readers_from_word(word) } +
      words_with_num_and_affix_tags.map { |word| convert_hankaku_katakana_to_zenkaku_katakana(word) } +
      words_with_num_and_affix_tags.map { |word| convert_zenkaku_numbers_to_hankaku_numbers(word) } +
      words_with_noun_and_noun_tags +
      words_with_noun_and_noun_tags.map { |word| remove_all_three_point_readers_from_word(word) } +
      words_with_noun_and_noun_tags.map { |word| convert_hankaku_katakana_to_zenkaku_katakana(word) } +
      words_with_noun_and_noun_tags.map { |word| convert_zenkaku_numbers_to_hankaku_numbers(word) } +
      words_with_noun_and_x_tags +
      words_with_noun_and_x_tags.map { |word| remove_all_three_point_readers_from_word(word) } +
      words_with_noun_and_x_tags.map { |word| convert_hankaku_katakana_to_zenkaku_katakana(word) } +
      words_with_noun_and_x_tags.map { |word| convert_zenkaku_numbers_to_hankaku_numbers(word) }
    ).uniq.reject(&:empty?)
  end
  # rubocop:enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

  private

  ###################################################################
  # NOUN - PUNCT - NOUN という並びのタグの部分を抽出する
  # 「ヤム・クー」などを抽出する
  ###################################################################
  def words_with_noun_and_punct_and_noun_tags
    words_with_noun_and_punct_and_noun_tags = []
    target_start_index_numbers = token_start_index_numbers_with_noun_and_punct_and_noun_tags

    target_start_index_numbers.each do |index_number|
      word = hashed_tokens[index_number]['lemma'] + hashed_tokens[index_number + 1]['lemma'] + hashed_tokens[index_number + 2]['lemma']

      words_with_noun_and_punct_and_noun_tags << word
    end

    words_with_noun_and_punct_and_noun_tags
  end

  def token_start_index_numbers_with_noun_and_punct_and_noun_tags
    target_tags = ['NOUN', 'PUNCT', 'NOUN'].freeze
    tokens = convert_analyze_syntax_response_token_objects
    tags_array = tokens.map(&:tag)
    token_start_index_numbers = []

    # 3つの要素の配列の判別をするために、配列の大きさから 2 を引いた index まで調べる
    (tags_array.count - 2).times.each do |i|
      target_array_in_tokens = [
        tags_array[i],
        tags_array[i + 1],
        tags_array[i + 2],
      ]

      token_start_index_numbers << i if target_array_in_tokens == target_tags
    end

    token_start_index_numbers
  end

  ###################################################################
  # NOUN - X という並びのタグの部分を抽出する
  # 「テンガアール」などを抽出する
  ###################################################################
  def words_with_noun_and_x_tags
    words_with_noun_and_x_tags = []
    target_start_index_numbers = token_start_index_numbers_with_noun_and_x_tags

    target_start_index_numbers.each do |index_number|
      word = hashed_tokens[index_number]['lemma'] + hashed_tokens[index_number + 1]['lemma']

      words_with_noun_and_x_tags << word
    end

    words_with_noun_and_x_tags
  end

  def token_start_index_numbers_with_noun_and_x_tags
    target_tags = ['NOUN', 'X'].freeze
    tokens = convert_analyze_syntax_response_token_objects
    tags_array = tokens.map(&:tag)
    token_start_index_numbers = []

    # 2つの要素の配列の判別をするために、配列の大きさから 1 を引いた index まで調べる
    (tags_array.count - 1).times.each do |i|
      target_array_in_tokens = [
        tags_array[i],
        tags_array[i + 1],
      ]

      token_start_index_numbers << i if target_array_in_tokens == target_tags
    end

    token_start_index_numbers
  end

  ###################################################################
  # NOUN - NOUN という並びのタグの部分を抽出する
  # 「ルカ様」などを抽出する
  ###################################################################
  def words_with_noun_and_noun_tags
    words_with_noun_and_noun_tags = []
    target_start_index_numbers = token_start_index_numbers_with_noun_and_noun_tags

    target_start_index_numbers.each do |index_number|
      word = hashed_tokens[index_number]['lemma'] + hashed_tokens[index_number + 1]['lemma']

      words_with_noun_and_noun_tags << word
    end

    words_with_noun_and_noun_tags
  end

  def token_start_index_numbers_with_noun_and_noun_tags
    target_tags = ['NOUN', 'NOUN'].freeze
    tokens = convert_analyze_syntax_response_token_objects
    tags_array = tokens.map(&:tag)
    token_start_index_numbers = []

    # 2つの要素の配列の判別をするために、配列の大きさから 1 を引いた index まで調べる
    (tags_array.count - 1).times.each do |i|
      target_array_in_tokens = [
        tags_array[i],
        tags_array[i + 1],
      ]

      token_start_index_numbers << i if target_array_in_tokens == target_tags
    end

    token_start_index_numbers
  end

  ###################################################################
  # NOUN - AFFIX という並びのタグの部分を抽出する
  # 「ルカ様」などを抽出する
  ###################################################################
  def words_with_noun_and_affix_tags
    words_with_noun_and_affix_tags = []
    target_start_index_numbers = token_start_index_numbers_with_noun_and_affix_tags

    target_start_index_numbers.each do |index_number|
      word = hashed_tokens[index_number]['lemma'] + hashed_tokens[index_number + 1]['lemma']

      words_with_noun_and_affix_tags << word
    end

    words_with_noun_and_affix_tags
  end

  def token_start_index_numbers_with_noun_and_affix_tags
    target_tags = ['NOUN', 'AFFIX'].freeze
    tokens = convert_analyze_syntax_response_token_objects
    tags_array = tokens.map(&:tag)
    token_start_index_numbers = []

    # 2つの要素の配列の判別をするために、配列の大きさから 1 を引いた index まで調べる
    (tags_array.count - 1).times.each do |i|
      target_array_in_tokens = [
        tags_array[i],
        tags_array[i + 1],
      ]

      token_start_index_numbers << i if target_array_in_tokens == target_tags
    end

    token_start_index_numbers
  end

  ###################################################################
  # NUM - AFFIX という並びのタグの部分を抽出する
  # 「４様」などを抽出する
  ###################################################################
  def words_with_num_and_affix_tags
    words_with_num_and_affix_tags = []
    target_start_index_numbers = token_start_index_numbers_with_num_and_affix_tags

    target_start_index_numbers.each do |index_number|
      word = hashed_tokens[index_number]['lemma'] + hashed_tokens[index_number + 1]['lemma']

      words_with_num_and_affix_tags << word
    end

    words_with_num_and_affix_tags
  end

  def token_start_index_numbers_with_num_and_affix_tags
    target_tags = ['NUM', 'AFFIX'].freeze
    tokens = convert_analyze_syntax_response_token_objects
    tags_array = tokens.map(&:tag)
    token_start_index_numbers = []

    # 2つの要素の配列の判別をするために、配列の大きさから 1 を引いた index まで調べる
    (tags_array.count - 1).times.each do |i|
      target_array_in_tokens = [
        tags_array[i],
        tags_array[i + 1],
      ]

      token_start_index_numbers << i if target_array_in_tokens == target_tags
    end

    token_start_index_numbers
  end

  ###################################################################
  # NOUN タグだけに絞ろうとしたが ベルクート が VERB だったので例外的に追加
  ###################################################################
  def words_with_basic_filters
    filtered_tokens = convert_analyze_syntax_response_token_objects.select do |token|
      token.tag == 'NOUN' || token.tag == 'VERB'
    end

    filtered_tokens.map(&:lemma)
  end

  ###################################################################
  # 以下はヘルパ的メソッドなので、ここに書かなくてもいい
  ###################################################################

  ###################################################################
  # 得られた単語群から三点リーダを除外した単語群を作る
  # 「…ルカ」などで一つの NOUN として認識されてしまうため
  ###################################################################
  def remove_all_three_point_readers_from_word(word)
    word.gsub(/…/, '')
  end

  ###################################################################
  # 得られた単語群の半角カタカナを全角カタカナに変換する
  # 文字列完全一致でキャラ名と照合するため
  ###################################################################
  def convert_hankaku_katakana_to_zenkaku_katakana(word)
    NKF.nkf('-WwXm0', word)
  end

  ###################################################################
  # 全角英数字を半角英数字へ変換する
  # 「２主」などを「2主」などへ統一する
  ###################################################################
  def convert_zenkaku_numbers_to_hankaku_numbers(word)
    word.tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z')
  end

  ###################################################################
  # 配列の要素をカンマ区切り（ダブルクォート付）へ変換する
  ###################################################################
  def convert_array_to_comma_separated_with_double_quote(array)
    array.map { |element| "\"#{element}\"" }.join(",")
  end
end
