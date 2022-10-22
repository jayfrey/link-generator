class Url < ApplicationRecord
  include Rails.application.routes.url_helpers

  MAXLEN = 10
  MINLEN = 8

  has_many :statistics, dependent: :destroy_async
  belongs_to :users, class_name: 'User', foreign_key: :user_id, optional: true

  validates :url, url: true

  def as_json(options = {})
    only = [
      :id,
      :created_at,
      :slug,
      :url,
    ] + (options[:only] || [])

    methods = [
      :shortened_link,
      :analytics_link,
      :visit_count,
      :user_id,
    ] + (options[:methods] || [])

    new_options = options.merge(
      only: only,
      methods: methods,
    )

    super(new_options)
  end

  def shortened_link() = visit_path(slug)

  def analytics_link() = analytics_path(slug)

  def visit_count() = statistics.count

  def self.top_visited(limit = 10)
    Url.where(user_id: nil).joins(:statistics).group(:id).order('COUNT(statistics.id) DESC').take(limit)
  end

  def self.top_recent(limit = 10)
    all.where(user_id: nil).sort_by(&:created_at).reverse.take(limit)
  end

  def self.generate_random_string() = rand(36**(rand(MINLEN..MAXLEN))).to_s(36)

  # generate a slug
  def self.generate_slug(random_string = nil)
    random_string ||= generate_random_string

    while !where(slug: random_string).empty?
      random_string = generate_random_string
    end

    random_string
  end

  def record_statistics(remote_ip:, user_agent:, referrer:)
    reader = MaxMind::GeoIP2::Reader.new(
      database: "#{Rails.root}/vendor/GeoLite2-Country.mmdb",
    )

    country = begin
      reader.country(remote_ip).country.iso_code
    rescue MaxMind::GeoIP2::AddressNotFoundError
      'AQ' # use Antarctica for development purposes :sweat_smile:
    end

    stat = statistics.create(
      user_agent: user_agent,
      referrer: referrer,
      ip: remote_ip,
      country: country,
    )

    stat.count = visit_count

    stat
  end
end
