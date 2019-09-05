class AddBelongsToToDropins < ActiveRecord::Migration[4.2]
  def change
    add_reference :dropins, :rink, index: true
  end
end
