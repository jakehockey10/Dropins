class AddDefaultValueToUsersStateAgain < ActiveRecord::Migration[4.2]
  def change
    change_column_default :users, :state, :inactive
  end
end
