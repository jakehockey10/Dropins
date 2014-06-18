class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer :dropin_id
      t.string :ip
      t.string :express_token
      t.integer :express_payer_id

      t.timestamps
    end
  end
end
