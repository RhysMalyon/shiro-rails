# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    respond_to :json

    private

    def respond_with(current_user, _opts = {})
      if resource.persisted?
        render json: {
                 code: 201,
                 message: 'Signed up successfully'
               },
               status: :created
      else
        render json: {
                 code: 400,
                 message: "User couldn't be created succesfully. #{current_user.errors.full_messages.to_sentence}"
               },
               status: :bad_request
      end
    end
  end
end
