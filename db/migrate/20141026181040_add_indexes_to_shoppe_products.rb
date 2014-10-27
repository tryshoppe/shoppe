class AddIndexesToShoppeProducts < ActiveRecord::Migration
  def change
    add_index :shoppe_products, :parent_id
    add_index :shoppe_products, :sku
    add_index :shoppe_products, :product_category_id
    add_index :shoppe_products, :permalink
  end
end
