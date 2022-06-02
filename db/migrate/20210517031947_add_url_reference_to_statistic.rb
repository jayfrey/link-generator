class AddUrlReferenceToStatistic < ActiveRecord::Migration[6.1]
  def change
    add_reference :statistics, :url, null: false, foreign_key: true
  end
end
