class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :name
      t.string :image
      t.string :body
      t.references :user, foreign_key: true
      t.references :character, foreign_key: true
      
      t.datetime :created_at, null: false
    end
  end
end
