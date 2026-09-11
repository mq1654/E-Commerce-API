class Product < ApplicationRecord
  belongs_to :category

  has_many :options, dependent: :destroy
  has_many :variants, dependent: :destroy

  validates :name, presence: true
  validates :base_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
