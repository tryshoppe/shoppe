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

    # The product's categorizations
    #
    # @return [Shoppe::ProductCategorization]
    has_many :product_categorizations, dependent: :destroy, class_name: 'Shoppe::ProductCategorization', inverse_of: :product
    # The product's categories
    #
    # @return [Shoppe::ProductCategory]
    has_many :product_categories, class_name: 'Shoppe::ProductCategory', through: :product_categorizations

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
      product.validate :has_at_least_one_product_category
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

    # Return the first product category
    #
    # @return [Shoppe::ProductCategory]
    def product_category
      self.product_categories.first rescue nil
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

            product.product_categories << begin
              if Shoppe::ProductCategory.find_by(name: row["category_name"]).present?
                Shoppe::ProductCategory.find_by(name: row["category_name"])
              else
                Shoppe::ProductCategory.create(name: row["category_name"])
              end
            end

            product.save!

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

    # Validates

    def has_at_least_one_product_category
      errors.add(:base, 'must add at least one product category') if self.product_categories.blank?
    end

  end
end
