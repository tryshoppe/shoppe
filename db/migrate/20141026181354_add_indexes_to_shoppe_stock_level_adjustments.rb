class AddIndexesToShoppeStockLevelAdjustments < ActiveRecord::Migration
  def change
    add_index :shoppe_stock_level_adjustments, [:item_id, :item_type], name: 'index_shoppe_stock_level_adjustments_items'
    add_index :shoppe_stock_level_adjustments, [:parent_id, :parent_type], name: 'index_shoppe_stock_level_adjustments_parent'
  end
end
