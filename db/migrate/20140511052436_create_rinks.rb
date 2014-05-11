class CreateRinks < ActiveRecord::Migration
  def change
    create_table :rinks do |t|
      t.float :latitude
      t.float :longitude
      t.string :address
      t.string :name

      t.timestamps
    end
  end
end
