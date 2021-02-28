class AddFundamentalsToStocks < ActiveRecord::Migration[6.0]
  def change
    add_column :stocks, :pe_ratio, :float
    add_column :stocks, :peg_ratio, :float
    add_column :stocks, :forward_pe, :float
    add_column :stocks, :dividend_yield, :float
    add_column :stocks, :year_high, :float
    add_column :stocks, :year_low, :float
  end
end
