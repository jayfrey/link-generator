class ApiController < ActionController::API
  helper_method :current_user

  private

  def current_user
    session_id = Rack::Session::SessionId.new(params[:session_id])&.private_id if params[:session_id]
    session_record = Session.find_by(session_id: session_id) if session_id
    current_session = Marshal.load(Base64.decode64(session_record.data)) if session_record
    @current_user ||= User.find_by(id: current_session["current_user_id"]) if current_session
    @current_user
  end
end
