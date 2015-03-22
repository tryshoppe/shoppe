require 'roo'

module Shoppe
  class Product < ActiveRecord::Base

    self.table_name = 'shoppe_products'

    # Add dependencies for products
    require_dependency 'shoppe/product/product_attributes'
    require_dependency 'shoppe/product/variants'

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
    validates :permalink, :presence => true, :uniqueness => true, :permalink => true
    validates :sku, :presence => true
    validates :weight, :numericality => true
    validates :price, :numericality => true
    validates :cost_price, :numericality => true, :allow_blank => true

    # Before validation, set the permalink if we don't already have one
    before_validation { self.permalink = self.name.parameterize if self.permalink.blank? && self.name.is_a?(String) }

    # Before save, ensure that if we've entered an inclusive price, we use that to calculate the price
    before_save :consider_tax

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

    # The price, inclusive of any tax, for the product
    #
    # @return [BigDecimal]
    def price_including_tax
      latched_price_including_tax || calculated_price_including_tax
    end

    def price_including_tax=(value)
      @price_including_tax = value == nil ? nil : BigDecimal(value)
    end

    # Has the price including tax been changed?
    #
    # @return [Boolean]
    def price_including_tax_changed?
      latched_price_including_tax.present? && latched_price_including_tax.round(2) != calculated_price_including_tax.round(2)
    end

    # The price, inclusive of any tax, for the product.
    # Calculated by adding tax at the specified rate on
    # top of the price.
    #
    # @return [BigDecimal]
    def calculated_price_including_tax
      return self.default_variant.calculated_price_including_tax if self.default_variant
      tax_rate = self.tax_rate ? self.tax_rate.rate : BigDecimal(0)
      (self.price_was / BigDecimal(100) * tax_rate) + self.price_was
    end

    # Gets the latched value for price including tax
    # from the current product or the default variant
    #
    # @return [BigDecimal]
    def latched_price_including_tax
      self.default_variant ? self.default_variant.latched_price_including_tax : @price_including_tax
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
  
    # Imports products from a spreadsheet file
    # Example:
    #
    #   Shoppe:Product.import("path/to/file.csv")
    def self.import(file)
      spreadsheet = open_spreadsheet(file)
      spreadsheet.default_sheet = spreadsheet.sheets.first
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]

        # Don't import products where the name is blank
        unless row["name"].nil?
          if product = find_by(name: row["name"])
            # Dont import products with the same name but update quantities if they're not the same
            qty = row["qty"].to_i
            if qty > 0 && qty != product.stock
              product.stock_level_adjustments.create!(description: I18n.t('shoppe.import'), adjustment: qty)
            end
          else
            product = new
            product.name = row["name"]
            product.sku = row["sku"]
            product.description = row["description"]
            product.short_description = row["short_description"]
            product.weight = row["weight"]
            product.price = row["price"].nil? ? 0 : row["price"]

            product.product_category_id = begin
              if Shoppe::ProductCategory.find_by(name: row["category_name"]).present?
                # Find and set the category
                Shoppe::ProductCategory.find_by(name: row["category_name"]).id
              else
                # Create the category
                Shoppe::ProductCategory.create(name: row["category_name"]).id
              end
            end

            product.save!

            # Create quantities
            qty = row["qty"].to_i
            if qty > 0
              product.stock_level_adjustments.create!(description: I18n.t('shoppe.import'), adjustment: qty)
            end
          end
        end
      end
    end

    def self.open_spreadsheet(file)
      case File.extname(file.original_filename)
      when ".csv" then Roo::CSV.new(file.path)
      when ".xls" then Roo::Excel.new(file.path)
      when ".xlsx" then Roo::Excelx.new(file.path)
      else raise I18n.t('shoppe.imports.errors.unknown_format', filename: File.original_filename)
      end
    end

    private

    # Considers the latched tax inclusive price before
    # considering whether or not to adjust the price.
    def consider_tax
      if self.price_including_tax_changed?
        tax_rate = self.tax_rate ? self.tax_rate.rate : BigDecimal(0)
        tax_multiplier = BigDecimal(1) + (tax_rate / BigDecimal(100))
        price_excluding_tax = latched_price_including_tax / tax_multiplier
        self.default_variant ? self.default_variant.price = price_excluding_tax : self.price = price_excluding_tax
      end
      self.price_including_tax = nil
    end
  end
end
