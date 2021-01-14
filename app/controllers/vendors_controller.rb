# frozen_string_literal: true

class VendorsController < ApplicationController
  def create
    vendor = Vendor.create(vendor_params)
    if vendor.persisted?
      render json: { vendor: vendor }
    else
      render json: { message: vendor.errors.full_messages.to_sentence }, status: 422
    end
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
end
