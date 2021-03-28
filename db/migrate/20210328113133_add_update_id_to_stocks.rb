class AddUpdateIdToStocks < ActiveRecord::Migration[6.0]
  def change
    add_column :stocks, :update_id, :integer
  end
end
