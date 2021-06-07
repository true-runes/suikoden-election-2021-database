class AddBornAtColumnToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :born_at, :datetime
  end
end
