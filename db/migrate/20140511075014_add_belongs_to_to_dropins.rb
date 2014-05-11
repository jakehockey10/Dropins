class AddBelongsToToDropins < ActiveRecord::Migration
  def change
    add_reference :dropins, :rink, index: true
  end
end
