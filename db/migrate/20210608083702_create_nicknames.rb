class CreateNicknames < ActiveRecord::Migration[6.1]
  def change
    create_table :nicknames do |t|
      # Nickname に name ってのはちょっとイケてない
      t.string :name
      t.string :name_en

      t.timestamps
    end
  end
end
