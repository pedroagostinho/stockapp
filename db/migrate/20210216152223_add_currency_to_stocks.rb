class AddCurrencyToStocks < ActiveRecord::Migration[6.0]
  def change
    add_column :stocks, :currency, :string
  end
end
