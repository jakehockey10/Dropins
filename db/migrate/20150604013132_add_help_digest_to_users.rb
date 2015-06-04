class AddHelpDigestToUsers < ActiveRecord::Migration
  def change
    add_column :users, :help_digest, :string
  end
end
