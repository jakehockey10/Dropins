class TryThisDefaultValueThingOneMoreTimeBeforeICry < ActiveRecord::Migration[4.2]
  def change
    change_column :users, :state, :integer, default: 0
  end
end
