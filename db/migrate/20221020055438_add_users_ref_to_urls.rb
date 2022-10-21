class AddUsersRefToUrls < ActiveRecord::Migration[6.1]
  def change
    add_reference :urls, :user, null: true, foreign_key: { to_table: :users }
  end
end
