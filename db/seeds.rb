require "faker"
require "quick_random_records"
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# disable AR logger
old_logger = ActiveRecord::Base.logger
ActiveRecord::Base.logger = nil

User.find_or_create_by(
  name: 'member',
  email: 'member@example.com',
)

User.find_or_create_by(
  name: 'admin',
  email: 'admin@example.com',
  role: :admin,
)

MAX_REFERRERS = 3_000
C_60_DAYS_IN_SECONDS = 60.days.seconds
C_2_YEARS_IN_SECONDS = 2.years.seconds
MAX_VISITS = 1_000

REFERRER_URLS = Array.new(MAX_REFERRERS) { Faker::Internet.url }
num_urls = 1_000

def generate_visits(num, progress = "generating visists", countries: nil)
  updated_at = Time.now

  Parallel.map(num.times, progress: progress) do
    {
      user_agent: Faker::Internet.user_agent,
      referrer: REFERRER_URLS.sample,
      ip: Faker::Internet.public_ip_v4_address,
      country: countries&.sample || Faker::Address.country_code,
      updated_at: updated_at
    }
  end
end

if ENV["benchmark"]
  num_urls = 100_000
  phases = 10
  puts "trying to insert #{num_urls * phases} urls in the database"

  1.upto(phases) do |phase|
    created_at = updated_at = Time.now

    puts "generating urls #{phase} of #{phases}"
    records = Parallel.map(num_urls.times, progress: "generating urls") do |i|
      {
        slug: "#{i * phase}",
        url: "#{i * phase}.example.com",
        created_at: created_at,
        updated_at: updated_at,
      }
    end

    puts "inserting #{num_urls} records into the database"
    Url.insert_all records
  end

  Parallel.each(Url.random_records(500), progress: "generating stats") do |url|
    records = generate_visits(10_000)
      .sample(rand * MAX_VISITS)
      .each { _1[:created_at] = url.created_at + rand(1..C_60_DAYS_IN_SECONDS).seconds }
    url.statistics.insert_all! records unless records.empty?
  end
  Url.connection.reconnect!

else
  if Url.count > num_urls
    puts "exiting due to #{Url.count} urls present, greater than #{num_urls}"
    return
  end

  slugs = Set.new
  urls = Set.new

  slugs << Url.generate_random_string while slugs.size < num_urls
  urls << Faker::Internet.url while urls.size < num_urls

  slugs = slugs.to_a
  urls = urls.to_a

  puts "#{Url.count} urls found, generating extra #{num_urls} records"
  records = Parallel.map(num_urls.times, progress: "generating urls") do |i|
    timestamp = rand(C_2_YEARS_IN_SECONDS).seconds.ago
    { slug: slugs[i], url: urls[i], created_at: timestamp, updated_at: timestamp }
  end

  Url.insert_all records

  Parallel.each(Url.random_records(50), progress: "generating stats") do |url|
    records = generate_visits(200)
      .each { _1[:created_at] = url.created_at + rand(1..C_60_DAYS_IN_SECONDS).seconds }
    url.statistics.insert_all! records unless records.empty?
  end
  Url.connection.reconnect!

end

# reenable logger
ActiveRecord::Base.logger = old_logger

# create a known slug
hk_url = Url.find_or_create_by(
  url: "https://hivekind.com",
  slug: "hk",
)

puts "generating stats for hk url"
stats = generate_visits(200, "generating visits for hk url", countries: %w[MY US CA BR IN SG PH ES])
  .each { _1[:created_at] = hk_url.created_at + rand(1..C_60_DAYS_IN_SECONDS).seconds }
hk_url.statistics.insert_all! stats unless records.empty?
