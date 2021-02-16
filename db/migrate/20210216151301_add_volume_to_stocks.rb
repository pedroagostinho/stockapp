class AddVolumeToStocks < ActiveRecord::Migration[6.0]
  def change
    add_column :stocks, :volume, :integer
  end
end
