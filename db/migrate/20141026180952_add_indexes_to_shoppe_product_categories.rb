class AddIndexesToShoppeProductCategories < ActiveRecord::Migration
  def change
    add_index :shoppe_product_categories, :permalink
  end
end
