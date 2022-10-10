class AffiliatesController < ApplicationController
  def create
    affiliate = Vendor.find_by(primary_email: params[:primary_email])
    if affiliate && current_user.vendor.affiliates << affiliate
      render json: { massage: "Your affiliate network has been expanded with #{affiliate.name}" }, status: 201
    else
      render json: { message: 'We could not add this vendor to your affiliate network at this time' }, status: 422
    end
  end
end
