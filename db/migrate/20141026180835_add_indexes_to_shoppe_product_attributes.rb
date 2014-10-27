class AddIndexesToShoppeProductAttributes < ActiveRecord::Migration
  def change
    add_index :shoppe_product_attributes, :product_id
    add_index :shoppe_product_attributes, :key
    add_index :shoppe_product_attributes, :position
  end
end
