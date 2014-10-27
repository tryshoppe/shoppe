module Shoppe
  class Product < ActiveRecord::Base
  
    self.table_name = 'shoppe_products'  
  
    # Add dependencies for products
    require_dependency 'shoppe/product/product_attributes'
    require_dependency 'shoppe/product/variants'
    
    # Attachments for this product
    has_many :attachments, :as => :parent, :dependent => :destroy, :class_name => "Shoppe::Attachment"

    # Used for setting an array of product attributes which will be updated. Usually
    # received from a web browser.
    attr_accessor :attachments_array
    
    after_save do
      # After saving automatically try to update the product attachments based on the
      # the contents of the attachments_array array.
      if attachments_array.is_a?(Array)
        self.attachments.update_from_array(attachments_array)
      end
    end
    
    # Products have a default_image and a data_sheet
    attachment :default_image
    attachment :data_sheet
  
    # The product's category
    #
    # @return [Shoppe::ProductCategory]
    belongs_to :product_category, :class_name => 'Shoppe::ProductCategory'
    
    # The product's tax rate
    #
    # @return [Shoppe::TaxRate]
    belongs_to :tax_rate, :class_name => "Shoppe::TaxRate"
    
    # Ordered items which are associated with this product
    has_many :order_items, :dependent => :restrict_with_exception, :class_name => 'Shoppe::OrderItem', :as => :ordered_item
    
    # Orders which have ordered this product
    has_many :orders, :through => :order_items, :class_name => 'Shoppe::Order'
    
    # Stock level adjustments for this product
    has_many :stock_level_adjustments, :dependent => :destroy, :class_name => 'Shoppe::StockLevelAdjustment', :as => :item
  
    # Validations
    with_options :if => Proc.new { |p| p.parent.nil? } do |product|
      product.validates :product_category_id, :presence => true
      product.validates :description, :presence => true
      product.validates :short_description, :presence => true
    end
    validates :name, :presence => true
    validates :permalink, :presence => true, :uniqueness => true
    validates :sku, :presence => true
    validates :weight, :numericality => true
    validates :price, :numericality => true
    validates :cost_price, :numericality => true, :allow_blank => true
    
    # Before validation, set the permalink if we don't already have one
    before_validation { self.permalink = self.name.parameterize if self.permalink.blank? && self.name.is_a?(String) }
  
    # All active products
    scope :active, -> { where(:active => true) }
    
    # All featured products
    scope :featured, -> {where(:featured => true)}
    
    # All products ordered with default items first followed by name ascending
    scope :ordered, -> {order(:default => :desc, :name => :asc)}
        
    # Return the name of the product
    #
    # @return [String]
    def full_name
      self.parent ? "#{self.parent.name} (#{name})" : name
    end
    
    # Is this product orderable?
    #
    # @return [Boolean]
    def orderable?
      return false unless self.active?
      return false if self.has_variants?
      true
    end
    
    # The price for the product
    #
    # @return [BigDecimal]
    def price
      self.default_variant ? self.default_variant.price : read_attribute(:price)
    end

    # Is this product currently in stock?
    #
    # @return [Boolean]
    def in_stock?
      self.default_variant ? self.default_variant.in_stock? : (stock_control? ? stock > 0 : true)
    end
  
    # Return the total number of items currently in stock
    #
    # @return [Fixnum]
    def stock
      self.stock_level_adjustments.sum(:adjustment)
    end

    # Attachments
    def default_image
      self.attachments.for("default_image")
    end

    def data_sheet
      self.attachments.for("data_sheet")
    end
  
    # Search for products which include the given attributes and return an active record
    # scope of these products. Chainable with other scopes and with_attributes methods.
    # For example:
    #
    #   Shoppe::Product.active.with_attribute('Manufacturer', 'Apple').with_attribute('Model', ['Macbook', 'iPhone'])
    #
    # @return [Enumerable]
    def self.with_attributes(key, values)
      product_ids = Shoppe::ProductAttribute.searchable.where(:key => key, :value => values).pluck(:product_id).uniq
      where(:id => product_ids)
    end
  
  end
end
