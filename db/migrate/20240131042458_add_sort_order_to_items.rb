class AddSortOrderToItems < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :sort_order, :integer
  end
end
