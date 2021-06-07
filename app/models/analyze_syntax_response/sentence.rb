module AnalyzeSyntaxResponse
  class Sentence
    include ActiveModel::Model

    attr_accessor :text, :analyze_syntax_id

    def begin_offset
      text['beginOffset']
    end

    def content
      text['content']
    end
  end
end
