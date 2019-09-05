class AddEmailDropinCreatorToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :dropin_creator_email_digest, :string
    add_column :users, :dropin_creator_email_sent_at, :datetime
  end
end
