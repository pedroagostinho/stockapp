class AddNameToStocks < ActiveRecord::Migration[6.0]
  def change
    add_column :stocks, :name, :string
  end
end
