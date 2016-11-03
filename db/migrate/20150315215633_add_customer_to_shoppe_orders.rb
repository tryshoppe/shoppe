class AddCustomerToShoppeOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :shoppe_orders, :customer_id, :integer
  end
end
