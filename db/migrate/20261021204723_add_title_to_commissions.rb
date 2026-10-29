class AddTitleToCommissions < ActiveRecord::Migration[8.1]
  def change
    add_column :commissions, :title, :string
  end
end
