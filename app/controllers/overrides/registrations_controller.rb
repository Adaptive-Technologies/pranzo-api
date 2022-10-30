class Overrides::RegistrationsController < DeviseTokenAuth::RegistrationsController
  def render_create_success
    render json: {
        status: 'success',
        data: @resource.as_json
      }
  end
end
