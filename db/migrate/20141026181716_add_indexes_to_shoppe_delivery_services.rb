class AddIndexesToShoppeDeliveryServices < ActiveRecord::Migration
  def change
    add_index :shoppe_delivery_services, :active
    add_index :shoppe_delivery_service_prices, :delivery_service_id
    add_index :shoppe_delivery_service_prices, :min_weight
    add_index :shoppe_delivery_service_prices, :max_weight
    add_index :shoppe_delivery_service_prices, :price
  end
end
