class Report < ApplicationRecord
  def self.generate
    create!(
      top_browsers: top_browsers,
      top_visited_urls: top_visited_urls,
      url_count_per_month: url_count_per_month,
    )
  end

  def top_browsers
    Statistic.group(:user_agent)
      .count
      .sort_by { |_, v| -v }
      .to_h
  end

  def top_visited_urls
    Statistic.group(:referrer)
      .count
      .sort_by { |_, v| -v }
      .to_h
  end

  def url_count_per_month
    Url.where("created_at > ?", 1.year.ago)
      .order(created_at: :desc)
      .group_by { |url| url.created_at.beginning_of_month }
      .map { |k, v| { k.strftime("%Y-%m-%d") => v.count } }
  end
end
