class AddDescriptionToStock < ActiveRecord::Migration[6.0]
  def change
    add_column :stocks, :description, :text
  end
end
