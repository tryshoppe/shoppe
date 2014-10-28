require 'awesome_nested_set'

module Shoppe
  class ProductCategory < ActiveRecord::Base

    # Allow the nesting of product categories
    # :restrict_with_exception relies on a fix to the awesome_nested_set gem
    # which has been referenced in the Gemfile as we can't add a dependency
    # to a branch in the .gemspec
    acts_as_nested_set  dependent: :restrict_with_exception,
                        after_move: :set_ancestral_permalink
  
    self.table_name = 'shoppe_product_categories'
    
    # Categories have an image attachment
    attachment :image

    # All products within this category
    has_many :product_categorizations, dependent: :restrict_with_exception, class_name: 'Shoppe::ProductCategorization', inverse_of: :product_category
    has_many :products, class_name: 'Shoppe::Product', through: :product_categorizations

    # Validations
    validates :name, :presence => true
    validates :permalink, :presence => true, :uniqueness => true, :permalink => true

    # All categories ordered by their name ascending
    scope :ordered, -> { order(:name) }

    # Root (no parent) product categories only
    scope :without_parent, -> { where(parent_id: nil) }
 
    # No descendents
    scope :except_descendants, ->(record) { where.not(id: (Array.new(record.descendants) << record).flatten) }
    
    # Set the permalink on callback
    before_validation :set_permalink, :set_ancestral_permalink
    after_save :set_child_permalinks

    def combined_permalink
      if self.permalink_includes_ancestors && self.ancestral_permalink.present?
        "#{self.ancestral_permalink}/#{self.permalink}"
      else
        self.permalink
      end
    end

    private

    def set_permalink
      self.permalink = self.name.parameterize if self.permalink.blank? && self.name.is_a?(String)
    end

    def set_ancestral_permalink
      permalinks = Array.new
      self.ancestors.each do |category|
        permalinks << category.permalink
      end
      self.ancestral_permalink = permalinks.join '/'
    end

    def set_child_permalinks
      self.children.each do |category|
        category.save!  # save forces children to update their ancestral_permalink
      end
    end
  
  end
end
