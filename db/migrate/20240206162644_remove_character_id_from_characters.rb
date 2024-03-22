# このマイグレーションはキャラクターテーブルからcharcter_idカラムを取り除くためのものです
class RemoveCharacterIdFromCharacters < ActiveRecord::Migration[7.0]
  def change
    remove_column :characters, :character_id, :integer
  end
end
