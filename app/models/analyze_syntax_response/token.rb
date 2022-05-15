module AnalyzeSyntaxResponse
  class Token
    include ActiveModel::Model

    # rubocop:disable Naming/MethodName, Layout/EmptyLinesAroundAttributeAccessor
    attr_accessor :text, :partOfSpeech, :dependencyEdge, :lemma, :analyze_syntax_id
    # rubocop:enable Naming/MethodName, Layout/EmptyLinesAroundAttributeAccessor

    def tag
      # 戻り値は Google::Cloud::Language::V1::AnalyzeSyntaxResponse では Symbol だが、これは String である
      part_of_speech['tag']
    end

    def part_of_speech
      partOfSpeech
    end

    def dependency_edge
      dependencyEdge
    end
  end
end
