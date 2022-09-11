class CreateTextMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :text_messages do |t|
      t.string :to_number
      t.text :message
      t.string :message_id

      t.timestamps
    end

    add_index :text_messages, :to_number
    add_index :text_messages, :message_id
  end
end
