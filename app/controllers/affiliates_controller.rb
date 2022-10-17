class AffiliatesController < ApplicationController
  def create
    affiliate = Vendor.find_by(primary_email: params[:primary_email])
    if affiliate && current_user.vendor.affiliates << affiliate
      render json: { massage: I18n.t('affiliates.not_added', name: affiliate.name) }, status: 201
    else
      render json: { message: I18n.t('affiliates.not_added') }, status: 422
    end
  end
end
