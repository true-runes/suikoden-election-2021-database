class CreateCharaNameAndProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :chara_name_and_products do |t|

      t.timestamps
    end
  end
end
