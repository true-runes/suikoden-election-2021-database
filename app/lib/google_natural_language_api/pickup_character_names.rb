# https://googleapis.dev/ruby/google-cloud-language/latest/file.MIGRATING.html
# https://googleapis.dev/ruby/google-cloud-language-v1/latest/Google/Cloud/Language/V1/AnalyzeSyntaxResponse.html
# https://cloud.google.com/natural-language/#natural-language-api-demo
# GoogleNaturalLanguageApi::PickupCharacterNames.new.foobar

require "google/cloud/language"

module GoogleNaturalLanguageApi
  class PickupCharacterNames
    attr_reader :client

    def initialize
      @language = Google::Cloud::Language.language_service
      @client = Google::Cloud::Language.language_service
    end

    def create_analyze_syntax_object(tweet)
      response = analyze_tweet_syntax_by_api(tweet)

      ActiveRecord::Base.transaction do
        analyze_syntax = AnalyzeSyntax.new(
          language: response.language,
          sentences: response.sentences.map(&:to_json),
          tokens: response.tokens.map(&:to_json),
          tweet_id: tweet.id
        )

        analyze_syntax.save!
      end
    end

    def analyze_tweet_syntax_by_api(tweet)
      content = tweet.full_text
      document = { type: :PLAIN_TEXT, content: content }

      @language.analyze_syntax(document: document)
    end
  end
end
