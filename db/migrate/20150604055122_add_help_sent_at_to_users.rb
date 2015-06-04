class AddHelpSentAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :help_sent_at, :datetime
  end
end
