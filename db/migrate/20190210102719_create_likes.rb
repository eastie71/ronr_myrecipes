class CreateLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :likes do |t|
      t.integer :chef_id
      t.integer :recipe_id
    end
  end
end
