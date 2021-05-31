FactoryBot.define do
  factory :tweet do
    id_number { 192789663528910849 }
    full_text { "おはようございます！\nこんにちは！" }
    source { '<a href="http://twitter.com/download/iphone" rel="nofollow">Twitter for iPhone</a>' }
    in_reply_to_tweet_id_number { nil }
    in_reply_to_user_id_number { nil }
    is_retweet { false }
    language { 'ja' }
    is_public { true }
    tweeted_at { Time.zone.now.yesterday }
  end
end
