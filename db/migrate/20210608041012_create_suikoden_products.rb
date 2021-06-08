class CreateSuikodenProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :suikoden_products do |t|
      t.string :name
      t.string :english_name

      # 発売日とかハードとか……？

      t.timestamps
    end
  end
end
