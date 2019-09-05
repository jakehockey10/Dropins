class AddHelpDigestToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :help_digest, :string
  end
end
