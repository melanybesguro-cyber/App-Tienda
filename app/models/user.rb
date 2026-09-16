class User < ApplicationRecord
  has_secure_password

  has_many :orders, dependent: :destroy
  has_many :commissions, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: %w[customer admin] }

  def admin?
    role == "admin"
  end
end