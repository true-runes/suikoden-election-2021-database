class CreateMentionedUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :mentioned_users do |t|

      t.timestamps
    end
  end
end
