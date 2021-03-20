class AddPeEvolutionToStocks < ActiveRecord::Migration[6.0]
  def change
    add_column :stocks, :pe_ratio_evolution, :float
  end
end
