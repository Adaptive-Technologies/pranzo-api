# frozen_string_literal: true

class VendorsController < ApplicationController
  after_action :attach_logotype, only: %i[create update]
  rescue_from ActiveRecord::RecordInvalid, with: :render_error_message

  def create
    @vendor = if current_user && !current_user.admin?
                current_user.create_vendor(vendor_params.merge(users: [current_user]))
              else
                Vendor.create!(vendor_params)
              end

    if params[:user]
      user_create(@vendor)
    else
      current_user.update!(vendor: @vendor)
    end

    if @vendor.persisted?
      @vendor.reload
      render json: @vendor, serializer: Vendors::ShowSerializer, status: :created
    else
      render_error_message(@vendor)
    end
  end

  def show
    vendor = Vendor.find(params[:id])
    render json: vendor, serializer: Vendors::ShowSerializer
  end

  def update
    @vendor = Vendor.find(params[:id])
    @vendor.update!(vendor_params)
    render json: @vendor, serializer: Vendors::ShowSerializer
  end

  private

  def vendor_params
    params.require(:vendor).permit(
      :name, :vat_id, :description, :primary_email, :logotype,
      addresses_attributes: [:id, :street, :city, :country, :post_code, :_destroy]
    )
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation) if params[:user]
  end

  def attach_logotype
    logotype_param = params.dig(:vendor, :logotype)
    return unless logotype_param.present?
binding.pry
    if logotype_param.is_a?(String) && logotype_param.start_with?('data:image')
      # Handle base64 encoded string
      DecodeService.attach_image(logotype_param, @vendor, 'logotype')
    else
      # Handle file upload
      @vendor.logotype.attach(logotype_param)
    end
  end

  def user_create(vendor)
    user = User.find_or_create_by(email: user_params[:email]) do |instance|
      instance.update(user_params)
    end
    user.update!(vendor: vendor)
  end

  def render_error_message(exception)
    render json: { message: exception.record.errors.full_messages.to_sentence }, status: :unprocessable_entity
  end
end
