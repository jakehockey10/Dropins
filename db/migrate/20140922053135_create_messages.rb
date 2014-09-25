class CreateMessages < ActiveRecord::Migration
  def up
    create_table :messages do |t|
      t.string :subject
      t.text :body
      t.integer :recipient_id
      t.integer :sender_id

      t.timestamps
    end
  end

  def down
    drop_table :messages
  end
end
