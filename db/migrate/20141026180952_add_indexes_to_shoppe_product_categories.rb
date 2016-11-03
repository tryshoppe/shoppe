class AddIndexesToShoppeProductCategories < ActiveRecord::Migration[5.0]
  def change
    add_index :shoppe_product_categories, :permalink
  end
end
