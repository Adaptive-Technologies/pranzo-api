# frozen_string_literal: true

class Admin::UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:type] == 'short_list'
      users = User.employee
      render json: users, each_serializer: Users::ShowSerializer
    else
      render json: { message: 'Error: Please specify list type' }, status: :bad_request
    end
  end
end
