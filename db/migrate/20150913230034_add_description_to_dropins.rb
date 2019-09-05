class AddDescriptionToDropins < ActiveRecord::Migration[5.1]
  def change
    add_column :dropins, :description, :string
  end
end
