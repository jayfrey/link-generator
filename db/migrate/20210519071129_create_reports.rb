class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.json :top_visited_urls
      t.json :top_browsers
      t.json :url_count_per_month

      t.timestamps
    end
  end
end
