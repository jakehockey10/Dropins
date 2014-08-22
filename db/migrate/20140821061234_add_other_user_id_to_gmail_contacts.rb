class AddOtherUserIdToGmailContacts < ActiveRecord::Migration
  def change
    add_column :gmail_contacts, :other_user_id, :integer
  end
end
