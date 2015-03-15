class CreateShoppeProductTemplates < ActiveRecord::Migration
  def change
    create_table :shoppe_product_templates do |t|
      t.string :name

      t.timestamps
    end
  end
end
