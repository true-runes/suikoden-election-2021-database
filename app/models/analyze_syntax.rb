class AnalyzeSyntax < ApplicationRecord
  belongs_to :tweet

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
end
