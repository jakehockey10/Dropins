class AddFirstNameAndLastNameToUsers < ActiveRecord::Migration
  def up
    unless column_exists? :users, :first_name
      add_column :users, :first_name, :string
    end
    unless column_exists? :users, :second_name
      add_column :users, :second_name, :string
    end
    User.all.each do |user|
      name = user.name.split(' ')
      user.update_attributes!(first_name: name[0])
      user.update_attributes!(second_name: name[1])
    end
    if column_exists? :users, :name
      remove_column :users, :name
    end
  end

  def down
    add_column :users, :name, :string
    User.all.each do |user|
      user.update_attributes!(name: user.first_name + ' ' + user.second_name)
    end
    remove_column :users, :first_name
    remove_column :users, :second_name
  end
end
