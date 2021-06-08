class CreateCharacterNicknames < ActiveRecord::Migration[6.1]
  def change
    create_table :character_nicknames do |t|
      t.string :name

      t.timestamps
    end
  end
end
