# frozen_string_literal: true

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :configure_permitted_parameters, if: :devise_controller?
  around_action :switch_locale

  def switch_locale(&action)
    locale = request.headers['locale'] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  protected

  def configure_permitted_parameters
    added_attrs = %i[name]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
