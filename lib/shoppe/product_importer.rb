require 'roo'

module Shoppe
  class ProductImporter
    def initialize(file)
      @spreadsheet = open_spreadsheet(file)
    end

    def import!
      @spreadsheet.default_sheet = @spreadsheet.sheets.first
      header = @spreadsheet.row(1)

      (2..@spreadsheet.last_row).each do |i|
        row = Hash[[header, @spreadsheet.row(i)].transpose]

        row     = Row.new(row)
        product = Shoppe::Product.find_by(name: row.name)

        unless row.name.nil?
          if product
            if row.quantity > 0 && row.quantity != product.stock
              product.stock_level_adjustments
                .create!(description: I18n.t('shoppe.import'), adjustment: row.quantity)
            end
          else
            product = create_product(row)
            product.stock_level_adjustments
              .create!(description: I18n.t('shoppe.import'),
                       adjustment: row.quantity) if row.quantity > 0
          end
        end
      end
    end

    def create_product(row)
      product = Shoppe::Product.new(
        name: row.name,
        sku: row.sku,
        description: row.description,
        short_description: row.short_description,
        weight: row.weight,
        price: row.price,
        product_category_id: product_category(row)
      )
      product.save!
      product
    end

    def product_category(row)
      category = Shoppe::ProductCategory.find_by(name: row.category_name)
      if category
        category.id
      else
        Shoppe::ProductCategory.create(name: row.category_name).id
      end
    end

    private

    def open_spreadsheet(file)
      case File.extname(file.original_filename)
      when '.csv' then Roo::CSV.new(file.path)
      when '.xls' then Roo::Excel.new(file.path)
      when '.xls' then Roo::Excelx.new(file.path)
      else raise I18n.t('shoppe.imports.errors.unknown_format', filename: File.original_filename)
      end
    end

    class Row
      def initialize(row)
        @row = row
      end

      def name
        @row['name']
      end

      def sku
        @row['sku']
      end

      def description
        @row['description']
      end

      def short_description
        @row['short_description']
      end

      def weight
        @row['weight']
      end

      def price
        @row['price'].nil? ? 0 : @row['price']
      end

      def quantity
        @row['qty'].to_i
      end

      def category_name
        @row['category_name']
      end
    end
  end
end
