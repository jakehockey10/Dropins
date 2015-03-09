class ChangeDefaultValueOfUserState < ActiveRecord::Migration
  def change
    change_column_default :users, :state, nil
  end
end
