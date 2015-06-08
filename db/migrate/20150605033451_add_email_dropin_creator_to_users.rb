class AddEmailDropinCreatorToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_dropin_creator_digest, :string
    add_column :users, :email_dropin_creator_sent_at, :datetime
  end
end
