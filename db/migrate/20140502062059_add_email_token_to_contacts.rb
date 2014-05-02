class AddEmailTokenToContacts < ActiveRecord::Migration
  def up
    add_column :contacts, :email_token, :string
  end

  def down
    remove :contacts, :email_token, :string
  end
end
