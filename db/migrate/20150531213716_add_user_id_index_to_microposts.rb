class AddUserIdIndexToMicroposts < ActiveRecord::Migration
  def change
    remove_column :microposts, :user_id
    add_reference :microposts, :user, index: true, foreign_key: true
  end
end
