# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :find_voucher
  def create
    transaction = @voucher.transactions.create(
      date: Date.today, 
      amount: params[:value] ? params[:value].to_i : 1, 
      honored_by: params[:honored_by] &&  params[:honored_by] )
    points = params[:value] ? params[:value] : 1
    PassKitService.consume(@voucher.code, points) if @voucher.pass_kit_id?
    if transaction.persisted?
      @voucher.reload
      render json: {
        message: "Voucher #{@voucher.code} was updated with a new transaction",
        voucher: Vouchers::ShowSerializer.new(@voucher)
      }, status: 201
    else
      render json: { message: transaction.errors.full_messages.to_sentence }, status: 422
    end
  end

  private 

  def find_voucher
    @voucher = Voucher.find(params[:voucher_id])
  end
end
