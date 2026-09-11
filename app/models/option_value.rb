class OptionValue < ApplicationRecord
  belongs_to :option
  has_many :variant_option_values, dependent: :destroy
  has_many :variants, through: :variant_option_values

  validates :value, presence: true
end
