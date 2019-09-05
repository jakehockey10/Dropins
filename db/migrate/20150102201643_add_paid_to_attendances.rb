class AddPaidToAttendances < ActiveRecord::Migration[4.2]
  def change
    add_column :attendances, :paid, :boolean, default: false
  end
end
