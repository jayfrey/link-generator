class UrlReportJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    Report.generate
  end
end
