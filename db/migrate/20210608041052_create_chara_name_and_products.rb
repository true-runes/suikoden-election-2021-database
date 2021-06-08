class CreateCharaNameAndProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :chara_name_and_products do |t|
      t.references :character_name, foreign_key: true
      t.references :suikoden_product, foreign_key: true

      t.timestamps
    end
  end
end
