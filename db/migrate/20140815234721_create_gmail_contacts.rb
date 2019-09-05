class CreateGmailContacts < ActiveRecord::Migration[4.2]
  def change
    create_table :gmail_contacts do |t|
      t.string :name
      t.string :email
      t.references :user, index: true

      t.timestamps
    end
  end
end
