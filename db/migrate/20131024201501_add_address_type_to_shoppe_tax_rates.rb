class AddAddressTypeToShoppeTaxRates < ActiveRecord::Migration[5.0]
  def change
    add_column :shoppe_tax_rates, :address_type, :string
  end
end
