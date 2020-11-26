# frozen_string_literal: true

class TransactionsController < ApplicationController
  def create
    voucher = Voucher.find(params[:voucher_id])
    transaction = voucher.transactions.create(date: Date.today)
    if transaction.persisted?
      voucher.reload
      render json: {
        message: "Voucher #{voucher.code} was updated with a new transaction",
        voucher: Vouchers::ShowSerializer.new(voucher)
      }, status: 201
    else
      render json: { message: transaction.errors.full_messages.to_sentance }, status: 422
    end
  end
end
