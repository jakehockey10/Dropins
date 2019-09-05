class AddOwnerToDropins < ActiveRecord::Migration[4.2]
  def up
    add_column :dropins, :user_id, :integer
  end

  def down
    remove_column :dropins, :user_id, :integer
  end
end
