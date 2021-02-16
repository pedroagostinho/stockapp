class AddFieldsToStocks < ActiveRecord::Migration[6.0]
  def change
    add_column :stocks, :min_price, :float
    add_column :stocks, :min_price_date, :datetime
    add_column :stocks, :max_price, :float
    add_column :stocks, :max_price_date, :datetime
    add_column :stocks, :min_volume, :integer
    add_column :stocks, :min_volume_date, :datetime
    add_column :stocks, :max_volume, :integer
    add_column :stocks, :max_volume_date, :datetime
    add_column :stocks, :avg_volume, :float
    add_column :stocks, :price_score, :float
    add_column :stocks, :hype_score, :float
  end
end
