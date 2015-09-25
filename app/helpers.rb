module AppHelpers
  def current_user
    @current_user ||= User.get(session[:user_id])
  end

  def generate_password_token
    SecureRandom.base64(12)
  end
end
