class AddPaidToAttendances < ActiveRecord::Migration
  def change
    add_column :attendances, :paid, :boolean, default: false
  end
end
