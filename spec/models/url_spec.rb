require "rails_helper"

RSpec.describe Url, type: :model do
  context "slug generation" do
    let(:redirect_to) { "https://google.com" }
    let(:random_string) { "random_string" }

    it "generates a custom slug" do
      slug = Url.generate_slug(random_string)

      expect(slug).to eq(random_string)
    end

    it "prevents collisions" do
      slug = Url.generate_slug(random_string)
      Url.create(slug: slug, url: redirect_to)

      expect(Url.generate_slug).to_not eq(slug)
    end
  end

  context "visitation" do
    let(:url) { Url.create(slug: "google", url: "https://google.com") }
    let(:remote_ip) { '172.217.166.142' }
    let(:user_agent) { 'rspec' }
    let(:referrer) { 'rspec-rails' }

    it "generates statistics" do
      url.record_statistics(
        remote_ip: remote_ip,
        user_agent: user_agent,
        referrer: referrer,
      )

      stats = Statistic.where(ip: remote_ip)
      expect(stats.count).to eq 1
      expect(stats.first.user_agent).to eq(user_agent)
      expect(stats.first.referrer).to eq(referrer)
      expect(stats.first.country).to eq('US')
    end
  end

  context "top urls" do
    before(:context) do
      @dates = [
        1.year.ago, 2.years.ago, 3.years.ago,
        1.month.ago, 2.months.ago, 3.months.ago,
        1.week.ago, 2.weeks.ago, 3.weeks.ago,
        1.day.ago, 2.days.ago, 3.days.ago
      ]

      @dates.each.with_index do |created_at, i|
        url = Url.create(
          slug: Url.generate_slug,
          url: Faker::Internet.url,
          created_at: created_at,
        )

        i.times do
          url.record_statistics(
            remote_ip: Faker::Internet.public_ip_v4_address,
            user_agent: Faker::Internet.user_agent,
            referrer: Faker::Internet.url,
          )
        end
      end
    end

    it "returns the 10 urls most recently created" do
      top_recents = Url.top_recent

      expect(top_recents.count).to eq 10
      top_recents.each.with_index do |top_recent, i|
        date = @dates.sort.reverse[i]
        expect(top_recent.created_at).to be_within(1.second).of date
      end
    end

    it "returns the 10 urls most visited" do
      top_visiteds = Url.top_visited

      expect(top_visiteds.count).to eq 10
      expect(top_visiteds.first.visit_count).to be > top_visiteds.last.visit_count
    end
  end
end
