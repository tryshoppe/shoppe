class IncreaseMoneyPrecision < ActiveRecord::Migration
  def change
    change_column :shoppe_products, :price, :decimal, precision: 12, scale: 6
    change_column :shoppe_delivery_service_prices, :price, :decimal, precision: 12, scale: 6
    change_column :shoppe_order_items, :unit_price, :decimal, precision: 12, scale: 6
    change_column :shoppe_orders, :delivery_price, :decimal, precision: 12, scale: 6
  end
end