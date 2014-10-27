class AddIndexesToShoppePayments < ActiveRecord::Migration
  def change
    add_index :shoppe_payments, :order_id
    add_index :shoppe_payments, :parent_payment_id
  end
end
