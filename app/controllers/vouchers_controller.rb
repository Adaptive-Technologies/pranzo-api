# frozen_string_literal: true

class VouchersController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    voucher = Voucher.create(voucher_params)
    if voucher.persisted?
      render json: { message: 'Voucher was created' }, status: 201
    else
      render json: { message: voucher.errors.full_messages.to_sentence }, status: 422
    end
  end

  private

  def voucher_params
    params.require(:voucher).permit(:type, :paid)
  end
end
