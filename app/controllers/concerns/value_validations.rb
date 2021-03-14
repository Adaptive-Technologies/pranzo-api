module ValueValidations
  extend ActiveSupport::Concern

  included do
    def validate_servings_value
      unless Voucher::PERMITTED_SERVING_VALUES.include? value.to_i
        render json: { message: 'We couldn\'t create the voucher as requested.' }, status: 422
      end
    end

    def validate_cash_value
      unless Voucher::PERMITTED_CASH_VALUES.include? value.to_i
        render json: { message: 'You have to provide a valid value.' }, status: 422
      end
    end

    def value
      params[:voucher] ? params[:voucher][:value] : params[:value]
    end
  end

end