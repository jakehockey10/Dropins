class RemoveTypeFromGroups < ActiveRecord::Migration
  def change
    remove_column :groups, :type
  end
end
