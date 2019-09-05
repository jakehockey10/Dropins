class AddOtherUserIdToGmailContacts < ActiveRecord::Migration[4.2]
  def change
    add_column :gmail_contacts, :other_user_id, :integer
  end
end
