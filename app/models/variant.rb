class Variant < ApplicationRecord
  belongs_to :product

  has_many :variant_option_values, dependent: :destroy
  has_many :option_values, through: :variant_option_values

  validates :sku, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
