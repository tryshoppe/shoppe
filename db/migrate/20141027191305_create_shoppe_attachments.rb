class CreateShoppeAttachments < ActiveRecord::Migration
  def change
    create_table :shoppe_attachments do |t|
      t.integer :parent_id
      t.string :parent_type
      t.string :token
      t.string :file
      t.string :file_name
      t.integer :file_size
      t.string :file_type
      t.string :role

      t.timestamps
    end
  end
end
