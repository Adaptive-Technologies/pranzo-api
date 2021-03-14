# frozen_string_literal: true

class PurchasesController < ApplicationController
  before_action :get_vendor
  before_action :validate_servings_value, if: proc { params[:value] && params[:variant] == 'servings' }
  before_action :validate_cash_value, if: proc { params[:variant] == 'cash' }

  def create
    user = User.find_by_email params[:email]
    owner = Owner.create(user: user, email: user&.email || params[:email])
    value = params[:value] || Voucher::DEFAULT_SERVINGS_VALUE
    voucher = Voucher.create(
      owner: owner,
      value: value,
      active: true,
      issuer: @vendor.try(:system_user), # It's issued by a system user
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

  def validate_servings_value
    unless Voucher::PERMITTED_SERVING_VALUES.include? params[:value].to_i
      render json: { message: 'We couldn\'t create the voucher as requested.' }, status: 422
    end
  end

  def validate_cash_value
    unless Voucher::PERMITTED_CASH_VALUES.include? params[:value].to_i
      render json: { message: 'You have to provide a valid value.' }, status: 422
    end
  end
end
