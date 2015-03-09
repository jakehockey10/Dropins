class TryThisDefaultValueThingOneMoreTimeBeforeICry < ActiveRecord::Migration
  def change
    change_column :users, :state, :integer, default: 0
  end
end
