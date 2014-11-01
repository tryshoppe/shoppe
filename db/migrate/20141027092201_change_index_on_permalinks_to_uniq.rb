class ChangeIndexOnPermalinksToUniq < ActiveRecord::Migration
  def change
    remove_index :shoppe_products, :permalink
    add_index :shoppe_products, :permalink, unique: true

    remove_index :shoppe_product_categories, :permalink
    add_index :shoppe_product_categories, :permalink, unique: true
  end
end
