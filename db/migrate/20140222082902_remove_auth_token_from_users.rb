class RemoveAuthTokenFromUsers < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :auth_token
  end
end
