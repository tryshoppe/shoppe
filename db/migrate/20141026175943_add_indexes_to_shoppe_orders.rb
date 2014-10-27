class AddIndexesToShoppeOrders < ActiveRecord::Migration
  def change
    add_index :shoppe_orders, :token
    add_index :shoppe_orders, :delivery_service_id
    add_index :shoppe_orders, :received_at
  end
end
