class AddIndexesToShoppeOrders < ActiveRecord::Migration[5.0]
  def change
    add_index :shoppe_orders, :token
    add_index :shoppe_orders, :delivery_service_id
    add_index :shoppe_orders, :received_at
  end
end
