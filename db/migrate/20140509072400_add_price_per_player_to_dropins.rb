class AddPricePerPlayerToDropins < ActiveRecord::Migration[4.2]
  def up
    add_column :dropins, :price, :decimal, precision: 8, scale: 2
  end

  def down
    remove_column :dropins, :price, :decimal, precision: 8, scale: 2
  end
end
