class AddDefaultValueToUsersStateAgain < ActiveRecord::Migration
  def change
    change_column_default :users, :state, :inactive
  end
end
