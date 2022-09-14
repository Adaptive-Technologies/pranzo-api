# frozen_string_literal: true

class VendorsController < ApplicationController
  before_action :user_params_present, only: [:create]
  rescue_from ActiveModel::ValidationError, with: :render_error_message
  def create
    vendor = Vendor.create(vendor_params)
    user_create(vendor) unless user_params.values.any?(&:empty?)

    if vendor.persisted?
      render json: vendor, serializer: Vendors::ShowSerializer, status: 201
    else
      raise ActiveModel::ValidationError, vendor
    end
  end

  def show
    vendor = Vendor.find(params[:id])
    render json: { vendor: vendor }
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
    params.require(:user)
          .permit(:name, :email, :password, :password_confirmation)
  end

  def user_create(vendor)
    attributes = user_params.merge!(vendor_id: vendor.id)
    user = User.create(attributes)
    raise ActiveModel::ValidationError, user if user.invalid?
  end

  def user_params_present
    @user_params_message = user_params.values.any?(&:empty?) ? ' and remember to create a user account for yourself' : ''
  end

  def render_error_message(exception)
    render json: { message: exception.model.errors.full_messages.to_sentence.concat(@user_params_message) }, status: 422
  end
end
