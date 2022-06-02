module Api
  class UrlsController < ApiController
    # route only available for development and testing
    def new; end

    def create
      # return existing shortened url if already existing
      url = Url.find_by(url: params[:url])

      if !url
        slug = Url.generate_slug
        url = Url.create(url: params[:url], slug: slug)
      end

      if url.valid?
        render json: { success: true, data: { url: url } }
      else
        Rails.logger.error url.errors.messages
        render json: { success: false, errors: url.errors.messages }, status: :unprocessable_entity
      end
    end

    def show
      url = Url.find_by(slug: params[:id])

      if url
        render json: { success: true, data: { url: url.as_json(methods: [:statistics]) } }
      else
        render json: { success: false }, status: :not_found
      end
    end
  end
end
