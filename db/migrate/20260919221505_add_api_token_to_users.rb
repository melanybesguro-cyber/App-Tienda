class AddApiTokenToUsers < ActiveRecord::Migration[8.1]
  def change
    unless column_exists?(:users, :api_token)
      add_column :users, :api_token, :string
    end

    unless index_exists?(:users, :api_token, unique: true)
      add_index :users, :api_token, unique: true
    end
  end
end