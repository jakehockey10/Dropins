class CreateAttendances < ActiveRecord::Migration[4.2]
  def change
    create_table :attendances do |t|
      t.integer :user_id
      t.integer :dropin_id

      t.timestamps
    end
  end
end
