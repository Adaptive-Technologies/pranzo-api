# frozen_string_literal: true

class VendorsController < ApplicationController
  def create
    vendor = Vendor.create(vendor_params)
    if vendor.persisted? && user_create(vendor)
      render json: vendor, serializer: Vendors::ShowSerializer, status: 201
    else
      render json: { message: vendor.errors.full_messages.to_sentence }, status: 422
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
    if user.persisted?
      user
    else
      # error response?
    end
  end
end
