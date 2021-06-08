FactoryBot.define do
  factory :analyze_syntax do
    language { 'ja' }
    sentences {
      [
        "{\"text\":{\"content\":\"RT @foobar: オデッサを応援しています \\n#幻水総選挙運動\\n #幻水総選挙2021 https://t.co/3njNheDvPk\",\"beginOffset\":-1}}"
      ]
    }
    tokens {
      [
        "{\"text\":{\"content\":\"オデッサ\",\"beginOffset\":-1},\"partOfSpeech\":{\"tag\":\"NOUN\",\"proper\":\"PROPER\"},\"dependencyEdge\":{\"headTokenIndex\":8,\"label\":\"DOBJ\"},\"lemma\":\"オデッサ\"}",
        "{\"text\":{\"content\":\"を\",\"beginOffset\":-1},\"partOfSpeech\":{\"tag\":\"PRT\",\"case\":\"ACCUSATIVE\",\"proper\":\"NOT_PROPER\"},\"dependencyEdge\":{\"headTokenIndex\":6,\"label\":\"PRT\"},\"lemma\":\"を\"}",
        "{\"text\":{\"content\":\"応援\",\"beginOffset\":-1},\"partOfSpeech\":{\"tag\":\"NOUN\",\"proper\":\"NOT_PROPER\"},\"dependencyEdge\":{\"headTokenIndex\":8,\"label\":\"ROOT\"},\"lemma\":\"応援\"}",
        "{\"text\":{\"content\":\"し\",\"beginOffset\":-1},\"partOfSpeech\":{\"tag\":\"VERB\",\"form\":\"GERUND\",\"proper\":\"NOT_PROPER\"},\"dependencyEdge\":{\"headTokenIndex\":8,\"label\":\"MWV\"},\"lemma\":\"する\"}",
        "{\"text\":{\"content\":\"て\",\"beginOffset\":-1},\"partOfSpeech\":{\"tag\":\"PRT\",\"proper\":\"NOT_PROPER\"},\"dependencyEdge\":{\"headTokenIndex\":8,\"label\":\"PRT\"},\"lemma\":\"て\"}",
        "{\"text\":{\"content\":\"い\",\"beginOffset\":-1},\"partOfSpeech\":{\"tag\":\"VERB\",\"form\":\"GERUND\",\"proper\":\"NOT_PROPER\"},\"dependencyEdge\":{\"headTokenIndex\":8,\"label\":\"AUXVV\"},\"lemma\":\"い\"}",
        "{\"text\":{\"content\":\"ます\",\"beginOffset\":-1},\"partOfSpeech\":{\"tag\":\"VERB\",\"form\":\"ADNOMIAL\",\"proper\":\"NOT_PROPER\"},\"dependencyEdge\":{\"headTokenIndex\":8,\"label\":\"AUX\"},\"lemma\":\"ます\"}",
        "{\"text\":{\"content\":\"#\",\"beginOffset\":-1},\"partOfSpeech\":{\"tag\":\"X\",\"proper\":\"NOT_PROPER\"},\"dependencyEdge\":{\"headTokenIndex\":17,\"label\":\"NN\"},\"lemma\":\"#\"}",
        "{\"text\":{\"content\":\"幻\",\"beginOffset\":-1},\"partOfSpeech\":{\"tag\":\"NOUN\",\"proper\":\"PROPER\"},\"dependencyEdge\":{\"headTokenIndex\":15,\"label\":\"NN\"},\"lemma\":\"幻\"}",
        "{\"text\":{\"content\":\"水\",\"beginOffset\":-1},\"partOfSpeech\":{\"tag\":\"NOUN\",\"proper\":\"PROPER\"},\"dependencyEdge\":{\"headTokenIndex\":17,\"label\":\"NN\"},\"lemma\":\"水\"}",
        "{\"text\":{\"content\":\"総\",\"beginOffset\":-1},\"partOfSpeech\":{\"tag\":\"AFFIX\",\"proper\":\"PROPER\"},\"dependencyEdge\":{\"headTokenIndex\":17,\"label\":\"PREF\"},\"lemma\":\"総\"}",
        "{\"text\":{\"content\":\"選挙\",\"beginOffset\":-1},\"partOfSpeech\":{\"tag\":\"NOUN\",\"proper\":\"NOT_PROPER\"},\"dependencyEdge\":{\"headTokenIndex\":18,\"label\":\"NN\"},\"lemma\":\"選挙\"}",
        "{\"text\":{\"content\":\"運動\",\"beginOffset\":-1},\"partOfSpeech\":{\"tag\":\"NOUN\",\"proper\":\"NOT_PROPER\"},\"dependencyEdge\":{\"headTokenIndex\":23,\"label\":\"NN\"},\"lemma\":\"運動\"}",
      ]
    }
    # TODO: tweet_id { Tweet の Factory を作る }
  end
end
