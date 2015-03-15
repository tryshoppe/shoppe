class CreateShoppeAddresses < ActiveRecord::Migration
  def change
    create_table :shoppe_addresses do |t|
      t.belongs_to :customer, index: true
      t.string :address_type
      t.boolean :default
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :address4
      t.string :postcode
      t.integer :country_id

      t.timestamps
    end
  end
end
