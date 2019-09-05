class AddHelpSentAtToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :help_sent_at, :datetime
  end
end
