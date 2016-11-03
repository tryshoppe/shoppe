module Shoppe
  class Product < ApplicationRecord
    # Validations
    validate { errors.add :base, :can_belong_to_root if parent && parent.parent }

    # Variants of the product
    has_many :variants, class_name: 'Shoppe::Product', foreign_key: 'parent_id', dependent: :destroy

    # The parent product (only applies to variants)
    belongs_to :parent, class_name: 'Shoppe::Product', foreign_key: 'parent_id'

    # All products which are not variants
    scope :root, -> { where(parent_id: nil) }

    # If a variant is created, the base product should be updated so that it doesn't have stock control enabled
    after_save do
      if parent
        parent.price = 0
        parent.cost_price = 0
        parent.tax_rate = nil
        parent.weight = 0
        parent.stock_control = false
        parent.save if parent.changed?
      end
    end

    # Does this product have any variants?
    #
    # @return [Boolean]
    def has_variants?
      !variants.empty?
    end

    # Returns the default variant for the product or nil if none exists.
    #
    # @return [Shoppe::Product]
    def default_variant
      return nil if parent
      @default_variant ||= variants.find(&:default?)
    end

    # Is this product a variant of another?
    #
    # @return [Boolean]
    def variant?
      !parent_id.blank?
    end
  end
end
