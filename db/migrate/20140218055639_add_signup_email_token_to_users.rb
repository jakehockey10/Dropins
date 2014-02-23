class AddSignupEmailTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_token, :string
  end
end
