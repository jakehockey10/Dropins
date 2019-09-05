class AddDescriptionToDropins < ActiveRecord::Migration[4.2]
  def change
    add_column :dropins, :description, :string
  end
end
