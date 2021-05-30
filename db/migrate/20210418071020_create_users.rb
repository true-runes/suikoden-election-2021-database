class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.bigint :id_number, null: false
      t.string :name, null: false
      t.string :screen_name, null: false
      t.string :profile_image_url_https
      t.boolean :is_protected

      t.timestamps
    end

    add_index :users, :id_number, unique: true
    add_index :users, :name
    add_index :users, :screen_name
  end
end
