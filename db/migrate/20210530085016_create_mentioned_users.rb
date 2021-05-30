class CreateMentionedUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :mentioned_users do |t|
      t.bigint :id_number

      t.references :tweet

      t.timestamps
    end
  end
end
