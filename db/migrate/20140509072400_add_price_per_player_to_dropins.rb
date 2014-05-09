class AddPricePerPlayerToDropins < ActiveRecord::Migration
  def up
    add_column :dropins, :price, :decimal, precision: 8, scale: 2
  end

  def down
    remove_column :dropins, :price, :decimal, precision: 8, scale: 2
  end
end
