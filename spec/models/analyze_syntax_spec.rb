require 'rails_helper'

RSpec.describe AnalyzeSyntax, type: :model do
  let(:analyze_syntax) { build(:analyze_syntax) }

  let(:hashed_sentences) { analyze_syntax.hashed_sentences }
  let(:hashed_tokens) { analyze_syntax.hashed_tokens }

  let(:tokens) { analyze_syntax.convert_analyze_syntax_response_token_objects }
  let(:sentences) { analyze_syntax.convert_analyze_syntax_response_sentence_objects }

  describe "#hashed_tokens" do
    it 'tokens が Array in Hash で戻ってくること' do
      expect(hashed_tokens.instance_of?(Array)).to be_truthy
      expect(hashed_tokens.map(&:class).all? { |klass| klass == Hash }).to be_truthy
    end
  end

  describe "#hashed_sentences" do
    it 'sentences が Array in Hash で戻ってくること' do
      expect(hashed_sentences.instance_of?(Array)).to be_truthy
      expect(hashed_sentences.map(&:class).all? { |klass| klass == Hash }).to be_truthy
    end
  end

  describe "#convert_analyze_syntax_response_token_objects" do
    it 'tokens が Array in AnalyzeSyntaxResponse::Token で戻ってくること' do
      expect(tokens.instance_of?(Array)).to be_truthy
      expect(tokens.map(&:class).all? { |klass| klass == AnalyzeSyntaxResponse::Token }).to be_truthy
    end
  end

  describe "#convert_analyze_syntax_response_sentence_objects" do
    it 'sentences が Array in AnalyzeSyntaxResponse::Sentence で戻ってくること' do
      expect(sentences.instance_of?(Array)).to be_truthy
      expect(sentences.map(&:class).all? { |klass| klass == AnalyzeSyntaxResponse::Sentence }).to be_truthy
    end
  end
end

