class CreateShoppeProductTemplateAttributes < ActiveRecord::Migration
  def change
    create_table :shoppe_product_template_attributes do |t|
      t.string :key, null: false
      t.boolean :searchable, default: true, null: false
      t.boolean :public, default: true, null: false
      t.integer :position, default: 1, null: false
      t.references :product_template

      t.timestamps
    end

    add_index :shoppe_product_template_attributes, :product_template_id, name: :by_product_template
  end
end
