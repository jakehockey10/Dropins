class RemoveSpeakingLanguageFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :speaking_language
  end

  def down
    add_column :users, :speaking_language, :string
  end
end
