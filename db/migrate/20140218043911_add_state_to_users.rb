class AddStateToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :state, :integer
  end
end
