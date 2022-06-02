class AuthorizedApiController < ApiController
  before_action :authorized?

  private

  def authorized?
    render(json: { success: false }, status: :unauthorized) and return unless current_user
  end

  def authorized_as_admin?
    render(json: { success: false }, status: :unauthorized) and return unless current_user.admin?
  end
end
