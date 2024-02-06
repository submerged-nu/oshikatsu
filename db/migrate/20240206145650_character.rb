class Character < ActiveRecord::Migration[7.0]
  def change
    create_table :characters do |t|
      t.integer :character_id
      t.string :name
      t.timestamps                null: false
    end
  end
end
