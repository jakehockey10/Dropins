class AddDropinRemovalSentAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :dropin_removal_sent_at, :datetime
  end
end
