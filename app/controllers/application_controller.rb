# frozen_string_literal: true2

class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def authorized?
    if request.headers['Authorization'].present?
      jwt_payload = JWT.decode(
        request.headers['Authorization'].split(' ').last,
        Rails.application.credentials.devise_jwt_secret_key!
      ).first

      current_user = User.find_by(id: jwt_payload['sub'], jti: jwt_payload['jti'])
    end

    return current_user if current_user

    render json: {
      status: 401,
      message: 'Not authorized to access that route.'
    }, status: :unauthorized
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: %i[email password]
    )

    devise_parameter_sanitizer.permit(
      :account_update,
      keys: %i[email password]
    )
  end
end
