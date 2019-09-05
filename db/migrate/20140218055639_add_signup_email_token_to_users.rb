class AddSignupEmailTokenToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :email_token, :string
  end
end
