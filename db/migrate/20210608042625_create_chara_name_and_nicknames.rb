class CreateCharaNameAndNicknames < ActiveRecord::Migration[6.1]
  def change
    create_table :chara_name_and_nicknames do |t|
      t.references :character_name, foreign_key: true
      t.references :character_nickname, foreign_key: true

      t.timestamps
    end
  end
end
