class CreateSuikodenProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :suikoden_products do |t|

      t.timestamps
    end
  end
end
