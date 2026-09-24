class Commission < ApplicationRecord
  belongs_to :user
  belongs_to :order

  validates :description, presence: true
  validates :status, presence: true
  validates :deadline, presence: true
end
