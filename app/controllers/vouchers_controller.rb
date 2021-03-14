# frozen_string_literal: true

class VouchersController < ApplicationController
  before_action :authenticate_user!, only: %i[create]
  before_action :find_voucher, only: %i[show update]
  before_action :validate_servings_value, if: proc { voucher_params[:value] && voucher_params[:variant] == 'servings' }
  before_action :validate_cash_value, if: proc { voucher_params[:variant] == 'cash' }
  after_action :set_owner, only: %i[update]
  rescue_from ActiveRecord::RecordNotFound, with: :voucher_not_found

  def index
    vouchers = Voucher.all
    render json: vouchers, each_serializer: Vouchers::ShowSerializer
  end

  def show
    render json: @voucher, serializer: Vouchers::ShowSerializer if @voucher
  end

  def create
    voucher = Voucher.create(voucher_params.merge(issuer: current_user))
    if voucher.persisted?
      render json: { message: 'Voucher was created' }, status: 201
    else
      render json: { message: voucher.errors.full_messages.to_sentence }, status: 422
    end
  end

  def update
    if voucher_params[:command] == 'activate' && @voucher.activate!
      render json: { message: 'Voucher is now active' }, status: 201
    else
      render json: { message: @voucher.errors.full_messages.to_sentence }, status: 422
    end
  end

  private

  def find_voucher
    @voucher = Voucher.find_by!(code: params[:id])
  end

  def set_owner
    if params[:voucher][:email] && @voucher.owner.nil?
      user = User.find_by_email(params[:voucher][:email])
      associated_user = user || nil
      Owner.find_or_create_by(
        email: params[:voucher][:email],
        voucher: @voucher,
        user: associated_user
      )
    end
  end

  def voucher_params
    params.require(:voucher).permit(:value, :command, :owner, :variant)
  end

  def voucher_not_found
    render json: { message: 'The voucher code is invalid, try again.' }, status: 200
  end

  def validate_servings_value
    unless Voucher::PERMITTED_SERVING_VALUES.include? voucher_params[:value].to_i
      render json: { message: 'We couldn\'t create the voucher as requested.' }, status: 422
    end
  end

  def validate_cash_value
    unless Voucher::PERMITTED_CASH_VALUES.include? voucher_params[:value].to_i
      render json: { message: 'You have to provide a valid value.' }, status: 422
    end
  end
end
