# frozen_string_literal: true

class VouchersController < ApplicationController
  include ValueValidations

  before_action :authenticate_user!, only: %i[create]
  before_action :find_voucher, only: %i[show update]
  before_action :validate_servings_value, if: proc { voucher_params[:value] && voucher_params[:variant] == 'servings' }, only: :create
  before_action :validate_cash_value, if: proc { voucher_params[:variant] == 'cash' }, only: :create
  after_action :set_owner, only: %i[update]
  rescue_from ActiveRecord::RecordNotFound, with: :voucher_not_found

  def index
    vouchers = current_user.admin? ? Voucher.all : current_user.vendor.vouchers
    render json: vouchers, each_serializer: Vouchers::ShowSerializer
  end

  def show
    render json: @voucher, serializer: Vouchers::ShowSerializer if @voucher
  end

  def create
    # we need to validate current_user is a vendor
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

  def generate_card
    voucher = Voucher.find(params[:voucher_id])
    if voucher.generate_pdf_card then
      render json: { message: 'Card was successfylly generated', url: voucher.pdf_card_path}, status: :created
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
    render json: { message: 'The voucher code is invalid, try again.' }, status: 404
  end

end
