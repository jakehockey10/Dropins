class AddDropinRemovalDigestToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :dropin_removal_digest, :string
  end
end
