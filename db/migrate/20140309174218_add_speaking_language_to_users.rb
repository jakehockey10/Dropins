class AddSpeakingLanguageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :speaking_language, :string
  end
end
