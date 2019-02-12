class AddIndexToLikes < ActiveRecord::Migration[5.2]
  def change
    add_index :likes, [:recipe_id, :chef_id], unique: true
  end
end
