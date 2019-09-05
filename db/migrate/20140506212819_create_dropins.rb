class CreateDropins < ActiveRecord::Migration[4.2]
  def change
    create_table :dropins do |t|
      t.datetime :date

      t.timestamps
    end
  end
end
