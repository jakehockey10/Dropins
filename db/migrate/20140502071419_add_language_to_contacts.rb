class AddLanguageToContacts < ActiveRecord::Migration
  def up
    add_column :contacts, :language, :string
  end

  def down
    remove_column :contacts, :language, :string
  end
end
