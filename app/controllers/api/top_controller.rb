module Api
  class TopController < ApiController
    def recent
      data = { recent: Url.top_recent }
      render json: { success: true, data: data }
    end

    def visited
      data = { visited: Url.top_visited }
      render json: { success: true, data: data }
    end
  end
end
