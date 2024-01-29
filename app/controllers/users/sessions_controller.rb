# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    respond_to :json

    private

    def respond_with(_current_user, _opts = {})
      render json: {
        status: {
          code: 200, message: 'Logged in successfully.'
        }
      }, status: :ok
    end

    def respond_to_on_destroy
      if authorized?
        render json: {
          status: 200,
          message: 'Logged out successfully.'
        }, status: :ok
      else
        render json: {
          status: 401,
          message: "Couldn't find an active session."
        }, status: :unauthorized
      end
    end
  end
end
