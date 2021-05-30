class CreateTweets < ActiveRecord::Migration[6.1]
  def change
    create_table :tweets do |t|
      t.bigint :id_number, null: false
      t.string :full_text
      t.string :source
      t.bigint :in_reply_to_tweet_id_number
      t.bigint :in_reply_to_user_id_number
      t.boolean :is_retweet
      t.string :language
      t.boolean :is_public
      t.datetime :tweeted_at

      t.references :user

      # t.string 'geo'
      # t.string 'coordinates'
      # t.string 'place'
      # t.boolean 'is_quote_status'
      # t.integer 'retweet_count'
      # t.integer 'favorite_count'
      # t.boolean 'favorited'
      # t.boolean 'possibly_sensitive'
      # t.boolean 'possibly_sensitive_appealable'

      t.timestamps
    end

    add_index :tweets, :id_number, unique: true
  end
end
