class AddDefaultValueToUserState < ActiveRecord::Migration[4.2]
  def change
    change_column_default :users, :state, 0
  end
end
