class AddLimitToDropins < ActiveRecord::Migration
  def up
    add_column :dropins, :limit, :integer
  end

  def down
    remove_column :dropins, :limit
  end
end
