class AddStatusToUserStocks < ActiveRecord::Migration[6.0]
  def change
    add_column :user_stocks, :status, :string
  end
end
