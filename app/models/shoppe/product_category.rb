require 'awesome_nested_set'

module Shoppe
  class ProductCategory < ApplicationRecord
    # Allow the nesting of product categories
    # :restrict_with_exception relies on a fix to the awesome_nested_set gem
    # which has been referenced in the Gemfile as we can't add a dependency
    # to a branch in the .gemspec
    acts_as_nested_set  dependent: :restrict_with_exception,
                        after_move: :set_ancestral_permalink

    self.table_name = 'shoppe_product_categories'

    # Attachments for this product category
    has_many :attachments, as: :parent, dependent: :destroy, class_name: 'Shoppe::Attachment'

    # All products within this category
    has_many :product_categorizations, dependent: :restrict_with_exception, class_name: 'Shoppe::ProductCategorization', inverse_of: :product_category
    has_many :products, class_name: 'Shoppe::Product', through: :product_categorizations

    # Validations
    validates :name, presence: true
    validates :permalink, presence: true, uniqueness: { scope: :parent_id }, permalink: true

    # Root (no parent) product categories only
    scope :without_parent, -> { where(parent_id: nil) }

    # No descendants
    scope :except_descendants, ->(record) { where.not(id: (Array.new(record.descendants) << record).flatten) }

    translates :name, :permalink, :description
    scope :ordered, -> { includes(:translations).order(:name) }

    # Set the permalink on callback
    before_validation :set_permalink, :set_ancestral_permalink
    after_save :set_child_permalinks

    def attachments=(attrs)
      attachments.build(attrs['image']) if attrs['image']['file'].present?
    end

    def combined_permalink
      if permalink_includes_ancestors && ancestral_permalink.present?
        "#{ancestral_permalink}/#{permalink}"
      else
        permalink
      end
    end

    # Return array with all the product category parents hierarchy
    # in descending order
    def hierarchy_array
      return [self] unless parent
      parent.hierarchy_array.concat [self]
    end

    # Attachment with the role image
    #
    # @return [String]
    def image
      attachments.for('image')
    end

    private

    def set_permalink
      self.permalink = name.parameterize if permalink.blank? && name.is_a?(String)
    end

    def set_ancestral_permalink
      permalinks = []
      ancestors.each do |category|
        permalinks << category.permalink
      end
      self.ancestral_permalink = permalinks.join '/'
    end

    def set_child_permalinks
      children.each(&:save!)
    end
  end
end
