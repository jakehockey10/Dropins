class ChangeDefaultValueOfUserState < ActiveRecord::Migration[4.2]
  def change
    change_column_default :users, :state, nil
  end
end
