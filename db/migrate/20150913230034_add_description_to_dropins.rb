class AddDescriptionToDropins < ActiveRecord::Migration
  def change
    add_column :dropins, :description, :string
  end
end
