class Recipe < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true, length: { minimum:5, maximum:500 }
  belongs_to :chef
  validates :chef_id, presence: true
  # Ordered by updated date in descending order - ie. latest recipes at the top
  default_scope -> { order(updated_at: :desc) }
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients
  # Destroy comments if destroying the recipe
  has_many :comments, dependent: :destroy
end