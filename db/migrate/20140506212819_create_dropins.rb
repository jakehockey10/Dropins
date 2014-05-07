class CreateDropins < ActiveRecord::Migration
  def change
    create_table :dropins do |t|
      t.datetime :date

      t.timestamps
    end
  end
end
