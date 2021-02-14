class AddRegionToStock < ActiveRecord::Migration[6.0]
  def change
    add_column :stocks, :region, :string
  end
end
