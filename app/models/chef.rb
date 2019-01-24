class Chef < ApplicationRecord
  before_save { self.email = email.downcase }
  validates :chefname, presence: true, length: {maximum: 60}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  # dependent destroy means recipes are removed on a chef destroy(delete)
  has_many :recipes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_secure_password
  validates :password, presence: true, length: {minimum: 5}, allow_nil: true
end
