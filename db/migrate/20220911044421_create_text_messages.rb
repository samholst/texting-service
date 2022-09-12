class CreateTextMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :text_messages do |t|
      t.string :to_number, null: false
      t.text :message, null: false
      t.string :message_id
      t.references :user, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end

    add_index :text_messages, :to_number
    add_index :text_messages, :message_id
  end
end
