class CreateCharacters < ActiveRecord::Migration[6.1]
  def change
    create_table :characters do |t|
      # ここでの name および name_en は幻水総選挙での呼び名とする（必ずしも公式ではない）
      t.string :name
      t.string :name_en

      t.timestamps
    end

    # 同名キャラが存在するため、UNIQUE を付けるのはいったん保留
    # add_index :characters, :name, unique: true
    # add_index :characters, :name_en, unique: true
  end
end
