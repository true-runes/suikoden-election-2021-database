class CreateCharaNameAndNickNames < ActiveRecord::Migration[6.1]
  def change
    create_table :chara_name_and_nick_names do |t|

      t.timestamps
    end
  end
end
