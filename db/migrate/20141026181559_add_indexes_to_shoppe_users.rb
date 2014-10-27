class AddIndexesToShoppeUsers < ActiveRecord::Migration
  def change
    add_index :shoppe_users, :email_address
  end
end
