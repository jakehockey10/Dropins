class AddLimitToDropins < ActiveRecord::Migration[4.2]
  def up
    add_column :dropins, :limit, :integer
  end

  def down
    remove_column :dropins, :limit
  end
end
