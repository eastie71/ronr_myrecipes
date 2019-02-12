class Like < ApplicationRecord
  belongs_to :chef
  belongs_to :recipe
  validates :chef_id, presence: true
  validates :recipe_id, presence: true
  # This ensures uniqueness of combination of chef and recipe
  validates :chef_id, uniqueness: { scope: :recipe_id }
end