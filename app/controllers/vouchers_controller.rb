# frozen_string_literal: true

class VouchersController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  rescue_from ActiveRecord::RecordNotFound, with: :voucher_not_found

  def index
    vouchers = Voucher.all
    render json: vouchers, each_serializer: Vouchers::ShowSerializer
  end

  def show
    voucher = Voucher.find_by!(code: params[:id])
    render json: voucher, serializer: Vouchers::ShowSerializer if voucher
  end

  def create
    voucher = Voucher.create(voucher_params)
    if voucher.persisted?
      render json: { message: 'Voucher was created' }, status: 201
    else
      render json: { message: voucher.errors.full_messages.to_sentence }, status: 422
    end
  end

  def update
    voucher = Voucher.find(params[:id])
    voucher.activate!
    if voucher.valid?
      render json: { message: 'Voucher is now active' }, status: 201
    else
      render json: { message: voucher.errors.full_messages.to_sentence }, status: 422
    end
  end

  private

  def voucher_params
    params.require(:voucher).permit(:value)
  end

  def voucher_not_found
    render json: { message: 'The voucher code is invalid, try again.' }, status: 404
  end
end
