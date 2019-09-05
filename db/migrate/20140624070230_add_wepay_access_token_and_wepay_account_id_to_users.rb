class AddWepayAccessTokenAndWepayAccountIdToUsers < ActiveRecord::Migration[4.2]
  def up
    add_column :users, :wepay_access_token, :string
    add_column :users, :wepay_account_id, :integer
  end

  def down
    remove_column :users, :wepay_access_token
    remove_column :users, :wepay_account_id
  end
end
