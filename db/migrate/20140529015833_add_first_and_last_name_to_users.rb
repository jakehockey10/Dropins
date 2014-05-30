class AddFirstAndLastNameToUsers < ActiveRecord::Migration
  def up
    add_column :users, :first_name, :string
    add_column :users, :second_name, :string
    User.all.each do |user|
      name = user.name.split(' ')
      user.update_attributes!(first_name: name[0])
      user.update_attributes!(second_name: name[1])
    end
    remove_column :users, :name
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
