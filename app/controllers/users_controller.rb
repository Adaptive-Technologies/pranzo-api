class UsersController < ApplicationController
  def validate_user
    user = User.find_by(email: params[:uid])
    if !user
      render json: { message: 'ok' }
    else
      render json: { message: 'conflict' }
    end
  end
end
