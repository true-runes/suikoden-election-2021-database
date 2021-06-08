class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :name_en

      # 発売日とかハードとかWebページとか……？
      # コラボ作品とかも？（そうすると変数名を再考したい）

      t.timestamps
    end

    add_index :products, :name, unique: true
    add_index :products, :name_en, unique: true
  end
end
