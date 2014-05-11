class CreateRinks < ActiveRecord::Migration
  def change
    create_table :rinks do |t|
      t.string :name
      t.string :address

      t.timestamps
    end
  end
end
