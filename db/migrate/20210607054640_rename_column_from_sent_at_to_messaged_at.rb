class RenameColumnFromSentAtToMessagedAt < ActiveRecord::Migration[6.1]
  def change
    rename_column :direct_messages, :sent_at, :messaged_at
  end
end
