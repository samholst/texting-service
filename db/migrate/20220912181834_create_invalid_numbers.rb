class CreateInvalidNumbers < ActiveRecord::Migration[6.0]
  def change
    create_table :invalid_numbers do |t|
      t.string :number

      t.timestamps
    end


    add_index :invalid_numbers, :number
  end
end
