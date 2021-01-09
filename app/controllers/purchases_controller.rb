# frozen_string_literal: true

class PurchasesController < ApplicationController
  # before_action :get_vendor
  def create
    user = User.find_by_email params[:email]
    owner = Owner.create(user: user, email: user&.email || params[:email])
    value = params[:value] || 10
    # TODO: this is a ploblem now that we have Vouchers that have issuers and vendors
    voucher = Voucher.create(owner: owner, value: value, active: true)
    if voucher.persisted?
      render json: { message: 'success', voucher: voucher }, status: 201
    else
      render json: { message: voucher.errors.full_messages.to_sentence }, status: 422
    end
  end
end