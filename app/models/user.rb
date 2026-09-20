class User < ApplicationRecord
  has_secure_password
  has_secure_token :api_token

  has_many :orders, dependent: :destroy
  has_many :commissions, dependent: :destroy
  has_many :products, foreign_key: :artist_id, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true,
                   inclusion: { in: %w[customer artist admin] }

  def admin?
    role == "admin"
  end

  def artist?
    role == "artist"
  end

  def customer?
    role == "customer"
  end
end