class CreateShoppePayments < ActiveRecord::Migration[5.0]
  def up
    create_table :shoppe_payments do |t|
      t.integer :order_id
      t.decimal :amount, precision: 8, scale: 2, default: 0.0
      t.string :reference, :method
      t.boolean :confirmed, default: true
      t.boolean :refundable, default: false
      t.decimal :amount_refunded, precision: 8, scale: 2, default: 0.0
      t.integer :parent_payment_id
      t.boolean :exported, default: false
      t.timestamps
    end
    remove_column :shoppe_orders, :paid_at
    remove_column :shoppe_orders, :payment_reference
    remove_column :shoppe_orders, :payment_method

    add_column :shoppe_orders, :amount_paid, :decimal, precision: 8, scale: 2, default: 0.0
    add_column :shoppe_orders, :exported, :boolean, default: false
    add_column :shoppe_orders, :invoice_number, :string
  end

  def down
    drop_table :shoppe_payments
    add_column :shoppe_orders, :paid_at, :datetime
    add_column :shoppe_orders, :payment_reference, :string
    add_column :shoppe_orders, :payment_method, :string
    remove_column :shoppe_orders, :amount_paid
    remove_column :shoppe_orders, :exported
    remove_column :shoppe_orders, :invoice_number
  end
end
