class AddArtistToProducts < ActiveRecord::Migration[8.1]
  def change
    add_reference :products,
                  :artist,
                  foreign_key: { to_table: :users }
  end
end