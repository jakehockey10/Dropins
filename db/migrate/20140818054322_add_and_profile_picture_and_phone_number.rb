class AddAndProfilePictureAndPhoneNumber < ActiveRecord::Migration
  def up
    add_column :gmail_contacts, :profile_picture, :string
    add_column :gmail_contacts, :phone_number, :string
  end

  def down
    remove_column :gmail_contacts, :profile_picture
    remove_column :gmail_contacts, :phone_number
  end
end
