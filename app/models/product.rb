class Product < ApplicationRecord
  belongs_to :artist, class_name: "User"
  belongs_to :category
  has_one_attached :image
  has_many :order_items, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
