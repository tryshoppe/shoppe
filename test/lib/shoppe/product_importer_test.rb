require 'test_helper'
require 'roo'

module Shoppe
  class ProductImporterTest < ActiveSupport::TestCase

    setup do
      @file = Rack::Multipart::UploadedFile.new(
        File.join(File.dirname(__FILE__),'../../fixtures/csv/products.csv'))

      #This attributes are the same inside ../../fixtures/csv/products.csv
      @row = {
        "category_name"=>"Yealink T20P",
        "name"=>"YL-SIP-T20P",
        "sku"=>"yealink-t20p",
        "description"=>"product description",
        "short_description"=>"my short description",
        "weight"=>"1.119",
        "qty"=>"200",
        "price"=>"44.99"
      }
    end

    test "product creation" do
      Shoppe::ProductImporter.new(@file).import!
      product = Product.last

      assert_equal product.name, @row['name']
      assert_equal product.sku, @row['sku']
      assert_equal product.description, @row['description']
      assert_equal product.short_description, @row['short_description']
      assert_equal product.weight, BigDecimal(@row['weight'])
      assert_equal product.price, BigDecimal(@row['price'])
      assert_equal product.product_category.name, @row['category_name']
    end

    test "spreadsheet rows" do
      row = Shoppe::ProductImporter::Row.new(@row)

      assert_equal row.name, @row['name']
      assert_equal row.sku, @row['sku']
      assert_equal row.description, @row['description']
      assert_equal row.short_description, @row['short_description']
      assert_equal row.weight, @row['weight']
      assert_equal row.price, @row['price']
      assert_equal row.quantity, @row['qty'].to_i
      assert_equal row.category_name, @row['category_name']
    end
  end
end