class CreateCommissions < ActiveRecord::Migration[8.1]
  def change
    create_table :commissions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.text :description
      t.string :status
      t.date :deadline

      t.timestamps
    end
  end
end
