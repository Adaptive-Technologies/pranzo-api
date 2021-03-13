# frozen_string_literal: true

class PurchasesController < ApplicationController
  before_action :get_vendor
  def create
    user = User.find_by_email params[:email]
    owner = Owner.create(user: user, email: user&.email || params[:email])
    value = params[:value] || 10 # TODO: fix this magic number
    voucher = Voucher.create(
      owner: owner,
      value: value,
      active: true,
      issuer: @vendor.try(:system_user),
      variant: params[:variant]
    )
    if voucher.persisted?
      render json: { message: 'success', voucher: voucher }, status: 201
    else
      # TODO: Change the error message for missisng :variant
      # the genric one is not good UX
      # a better message is "You have to provide a voucher variant"
      render json: { message: voucher.errors.full_messages.to_sentence }, status: 422
    end
  end

  private

  def get_vendor
    @vendor = Vendor.find_by!(name: params['vendor'])
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'You have to provide a vendor' }, status: 422
  end
end
