class CreateCommitments < ActiveRecord::Migration
  def change
    create_table :commitments do |t|
      t.integer :user_id
      t.integer :dropin_id

      t.timestamps
    end
    add_index :commitments, :user_id
    add_index :commitments, :dropin_id
    add_index :commitments, [:user_id, :dropin_id], unique: true
  end
end
