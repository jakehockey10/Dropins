class RemoveLearningLanguageFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :learning_language
  end

  def down
    add_column :users, :learning_language, :string
  end
end
