class AddIndexesToShoppeUsers < ActiveRecord::Migration[5.0]
  def change
    add_index :shoppe_users, :email_address
  end
end
