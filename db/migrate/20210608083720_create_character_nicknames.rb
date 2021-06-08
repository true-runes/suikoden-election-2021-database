class CreateCharacterNicknames < ActiveRecord::Migration[6.1]
  def change
    create_table :character_nicknames do |t|
      t.references :character, foreign_key: true
      t.references :nickname, foreign_key: true

      t.timestamps
    end
  end
end
