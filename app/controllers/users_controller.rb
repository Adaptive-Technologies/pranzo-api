class UsersController < ApplicationController
  def validate_user
    user = params[:command] == 'vendor' ? Vendor.find_by(primary_email: params[:uid]) : User.find_by(email: params[:uid]) 
    if !user
      render json: { message: 'ok' }
    else
      render json: { message: 'conflict' }
    end
  end
end
