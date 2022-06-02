class CreateStatistics < ActiveRecord::Migration[6.1]
  def change
    create_table :statistics do |t|
      t.string :user_agent
      t.string :referrer
      t.string :ip
      t.string :country

      t.timestamps
    end
  end
end
