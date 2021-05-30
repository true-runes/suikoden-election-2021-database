class CreateInTweetUrls < ActiveRecord::Migration[6.1]
  def change
    create_table :in_tweet_urls do |t|
      t.string :text

      t.references :tweet

      t.timestamps
    end

    add_index :in_tweet_urls, [:tweet_id, :text], unique: true
  end
end
