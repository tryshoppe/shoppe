class AddIndexesToShoppeSettings < ActiveRecord::Migration[5.0]
  def change
    add_index :shoppe_settings, :key
  end
end
