class AddDefaultValueToUserState < ActiveRecord::Migration
  def change
    change_column_default :users, :state, 0
  end
end
