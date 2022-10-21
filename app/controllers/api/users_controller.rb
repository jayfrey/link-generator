module Api
  class UsersController < AuthorizedApiController
    skip_before_action :authorized?, only: :whoami

    def whoami
      if current_user
        render json: { success: true, data: { current_user: current_user } }
      else
        render json: { success: false }, status: :unauthorized
      end
    end

    def links
      if current_user
        render json: { success: true, data: { urls: current_user.urls } }
      else
        render json: { success: false }, status: :unauthorized
      end
    end
  end
end
