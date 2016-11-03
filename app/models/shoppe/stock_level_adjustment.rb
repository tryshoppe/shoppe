module Shoppe
  class StockLevelAdjustment < ApplicationRecord
    # The orderable item which the stock level adjustment belongs to
    belongs_to :item, polymorphic: true

    # The parent (OrderItem) which the stock level adjustment belongs to
    belongs_to :parent, polymorphic: true

    # Validations
    validates :description, presence: true
    validates :adjustment, numericality: true
    validate { errors.add(:adjustment, I18n.t('shoppe.activerecord.attributes.stock_level_adjustment.must_be_greater_or_equal_zero')) if adjustment == 0 }

    # All stock level adjustments ordered by their created date desending
    scope :ordered, -> { order(id: :desc) }
  end
end
