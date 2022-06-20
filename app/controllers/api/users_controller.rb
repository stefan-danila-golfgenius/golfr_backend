module Api
  # Controller that handles authorization and user data fetching
  class UsersController < ApplicationController
    include Devise::Controllers::Helpers
    before_action :logged_in!, only: :show

    def show
      user = User.find(params[:id])

      if user
        render json: {
          id: user.id,
          name: user.name,
          scores: user.scores
        }
      else
        render json: {
          errors: 'The user was not found'
        }, status: :bad_request
      end
    end

    def login
      user = User.find_by('lower(email) = ?', params[:email])
      if user.blank? || !user.valid_password?(params[:password])
        render json: {
          errors: [
            'Invalid email/password combination'
          ]
        }, status: :unauthorized
        return
      end

      sign_in(:user, user)

      render json: {
        user: {
          id: user.id,
          email: user.email,
          name: user.name,
          token: current_token
        }
      }.to_json
    end
  end
end
