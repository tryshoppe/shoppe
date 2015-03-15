class ChangeIndexOnPermalinksToUniq < ActiveRecord::Migration
  def up
    remove_index :shoppe_products, :permalink
    add_index :shoppe_products, :permalink, unique: true

    remove_index :shoppe_product_categories, :permalink
    add_index :shoppe_product_categories, :permalink, unique: true
  end

  def down
    remove_index :shoppe_products, :permalink
    add_index :shoppe_products, :permalink

    remove_index :shoppe_product_categories, :permalink
    add_index :shoppe_product_categories, :permalink
  end
end
