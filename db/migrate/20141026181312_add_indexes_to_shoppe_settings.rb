class AddIndexesToShoppeSettings < ActiveRecord::Migration
  def change
    add_index :shoppe_settings, :key
  end
end
