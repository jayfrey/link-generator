module Api
  class ReportsController < AuthorizedApiController
    before_action :authorized_as_admin?

    def create
      UrlReportJob.perform_later
      render json: { success: true }
    end

    def index
      render json: { success: true, data: { report_ids: Report.all.pluck(:id) } }
    end

    def show
      @report = Report.find(params[:report_id])
      render json: { success: true, data: { report: @report } }
    end
  end
end
