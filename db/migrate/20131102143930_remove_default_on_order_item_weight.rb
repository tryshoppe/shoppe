class RemoveDefaultOnOrderItemWeight < ActiveRecord::Migration[5.0]
  def up
    change_column_default :shoppe_order_items, :weight, nil
  end

  def down
    change_column_default :shoppe_order_items, :weight, 0.0
  end
end
