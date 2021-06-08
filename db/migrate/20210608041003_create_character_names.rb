class CreateCharacterNames < ActiveRecord::Migration[6.1]
  def change
    create_table :character_names do |t|

      t.timestamps
    end
  end
end
