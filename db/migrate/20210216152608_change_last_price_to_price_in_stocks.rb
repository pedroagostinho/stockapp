class ChangeLastPriceToPriceInStocks < ActiveRecord::Migration[6.0]
  def change
    rename_column :stocks, :last_price, :price
  end
end
