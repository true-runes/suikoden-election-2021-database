class CreateMentions < ActiveRecord::Migration[6.1]
  def change
    create_table :mentions do |t|
      t.bigint :user_id_number

      t.references :tweet

      t.timestamps
    end

    add_index :mentions, [:tweet_id, :user_id_number], unique: true
  end
end
