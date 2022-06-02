class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :destroy]

  def create
    @user = Authentication.find_or_create_from_auth_hash(auth_hash)

    if @user
      reset_session
      log_in @user

      callback = Addressable::URI.parse(origin)
      callback.query_values = (callback.query_values || {}).merge({ session_id: session.id.to_s })

      redirect_to callback.to_s
    else
      render json: { success: false }, status: :unauthorized
    end
  end

  def destroy
    reset_session
    redirect_to root_url, status: :see_other
  end

  protected

  def log_in(user)
    session[:current_user_id] = user.id
  end

  def log_out
    session.delete(:current_user_id)
  end

  def auth_hash
    request.env['omniauth.auth']
  end

  def origin
    request.env['omniauth.origin'] || root_url
  end
end
