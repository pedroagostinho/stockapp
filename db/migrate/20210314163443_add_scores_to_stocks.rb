class AddScoresToStocks < ActiveRecord::Migration[6.0]
  def change
    add_column :stocks, :current_price_score, :float
    add_column :stocks, :pe_ratio_score, :float
    add_column :stocks, :pe_evolution_score, :float
    add_column :stocks, :score, :float
  end
end
