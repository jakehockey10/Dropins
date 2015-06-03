class ChangeStateToActiveBoolean < ActiveRecord::Migration
  def change
    add_column :users, :activated, :boolean, default: false

    User.where(:state => 1).update_all(activated: true)

    remove_column :users, :state
  end
end
