# ツイートでメンションされたユーザー
class UserMention < User
  has_many :tweets
end
