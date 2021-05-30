class CreateUrls < ActiveRecord::Migration[6.1]
  def change
    create_table :urls do |t|
      t.string :text

      t.references :tweet

      t.timestamps
    end

    add_index :urls, :text, unique: true
  end
end
