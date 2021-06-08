class CreateCharacterNickNames < ActiveRecord::Migration[6.1]
  def change
    create_table :character_nick_names do |t|

      t.timestamps
    end
  end
end
