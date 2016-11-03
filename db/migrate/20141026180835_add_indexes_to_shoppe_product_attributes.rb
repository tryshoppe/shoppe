class AddIndexesToShoppeProductAttributes < ActiveRecord::Migration[5.0]
  def change
    add_index :shoppe_product_attributes, :product_id
    add_index :shoppe_product_attributes, :key
    add_index :shoppe_product_attributes, :position
  end
end
