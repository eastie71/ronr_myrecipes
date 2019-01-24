class Comment < ApplicationRecord
  validates :description, presence: true, length: { minimum: 3, maximum: 140}
  belongs_to :chef
  belongs_to :recipe
  validates :chef_id, presence: true
  validates :recipe_id, presence: true
  # Ordered by updated date in descending order - ie. latest comments at the top
  default_scope -> { order(updated_at: :desc) }
end