class CreateAssets < ActiveRecord::Migration[6.1]
  def change
    create_table :assets do |t|
      t.bigint :id_number
      t.string :url
      t.string :asset_type

      t.references :tweet

      t.timestamps
    end
  end
end
