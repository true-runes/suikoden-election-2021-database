class CreateDirectMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :direct_messages do |t|
      t.bigint :id_number
      t.datetime :sent_at
      t.string :text
      t.bigint :sender_id_number
      t.bigint :recipient_id_number
      t.boolean :is_visible

      t.references :user

      t.timestamps
    end

    add_index :direct_messages, :id_number, unique: true
  end
end
