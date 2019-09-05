class AddActivatedAtToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :activation_digest, :string
    add_column :users, :activated_at, :datetime
  end
end
