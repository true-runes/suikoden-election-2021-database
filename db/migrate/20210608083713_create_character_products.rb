class CreateCharacterProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :character_products do |t|
      t.references :character, foreign_key: true
      t.references :product, foreign_key: true

      t.timestamps
    end
  end
end
