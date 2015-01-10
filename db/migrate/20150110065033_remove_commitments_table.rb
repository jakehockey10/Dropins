class RemoveCommitmentsTable < ActiveRecord::Migration
  def change
    drop_table :commitments
  end
end
