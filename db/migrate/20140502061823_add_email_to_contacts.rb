class AddEmailToContacts < ActiveRecord::Migration
  def up
    add_column :contacts, :email, :string
  end

  def down
    remove_column :contacts, :email, :string
  end
end
