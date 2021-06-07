class AddResponseColumnToDirectMessage < ActiveRecord::Migration[6.1]
  def change
    add_column :direct_messages, :api_response, :text
  end
end
