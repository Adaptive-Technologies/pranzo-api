# frozen_string_literal: true

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :configure_permitted_parameters, if: :devise_controller?
  around_action :switch_locale
  # before_action :set_devise_locale, unless: :is_edit_password_action?

  # def set_devise_locale
  #   I18n.locale = request.headers['locale']&.to_sym || I18n.default_locale 
  # end

  def switch_locale(&action) 
    locale = request.headers['locale']&.to_sym || I18n.default_locale
    I18n.with_locale(locale, &action) 
  end

  protected

  # def is_edit_password_action?
  #   controller_path == "devise_token_auth/passwords" && action_name == "edit"
  # end

  def configure_permitted_parameters
    added_attrs = %i[name]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
