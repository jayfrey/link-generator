class Statistic < ApplicationRecord
  belongs_to :url

  default_scope -> { order(created_at: :desc) }

  attribute :count, default: 1

  def as_json(options = {})
    super(options.merge(
      except: [
        :updated_at,
        :url_id,
      ], methods: []
    ))
  end
end
