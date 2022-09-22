# frozen_string_literal: true

class VendorsController < ApplicationController
  # before_action :user_params_present, only: [:create]
  rescue_from ActiveModel::ValidationError, with: :render_error_message
  def create
    vendor = Vendor.create(vendor_params)
    params[:user] ? user_create(vendor) : current_user.update(vendor: vendor)

    if vendor.persisted?
      render json: vendor, serializer: Vendors::ShowSerializer, status: 201
    else
      raise ActiveModel::ValidationError, vendor
    end
  end

  def show
    vendor = Vendor.find(params[:id])
    render json: vendor, serializer: Vendors::ShowSerializer
  end

  def update
    vendor = Vendor.find(params[:id])
    vendor.update(vendor_params)
    render json: vendor, serializer: Vendors::ShowSerializer
  end

  private

  def vendor_params
    params.require(:vendor)
          .permit(
            :name,
            :description,
            :primary_email,
            addresses_attributes: %i[street post_code city country]
          )
  end

  def user_params
    if params[:user]
      params.require(:user)
            .permit(:name, :email, :password, :password_confirmation)
    end
  end

  def user_create(vendor)
    user = User.find_or_create_by(email: user_params[:email]) do |instance|
      instance.update(user_params)
    end
    user.vendor = vendor
    user.save
    raise ActiveModel::ValidationError, user if user.invalid?
  end

  # def user_params_present
  #   @user_params_message = user_params.values.any?(&:empty?) ? ' and remember to create a user account for yourself' : ''
  # end

  def render_error_message(exception)
    render json: { message: exception.model.errors.full_messages.to_sentence.concat(@user_params_message) }, status: 422
  end
end
