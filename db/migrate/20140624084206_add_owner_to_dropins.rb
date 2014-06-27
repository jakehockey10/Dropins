class AddOwnerToDropins < ActiveRecord::Migration
  def up
    add_column :dropins, :user_id, :integer
  end

  def down
    remove_column :dropins, :user_id, :integer
  end
end
