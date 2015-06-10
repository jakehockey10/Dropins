class AddDropinRemovalDigestToUsers < ActiveRecord::Migration
  def change
    add_column :users, :dropin_removal_digest, :string
  end
end
