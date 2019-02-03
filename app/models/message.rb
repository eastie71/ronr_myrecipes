class Message < ApplicationRecord
  validates :content, presence: true, length: { minimum: 1, maximum: 140}
  belongs_to :chef
  validates :chef_id, presence: true
  # Ordered by updated date in descending order - ie. latest messages at the top
  default_scope -> { order(updated_at: :desc) }
  
  def self.most_recent
    order(:created_at).last(20)
  end
end