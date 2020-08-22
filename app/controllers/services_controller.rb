# frozen_string_literal: true

class ServicesController < ApplicationController
  def index

    render json: { services: ServicesService.list_available }
  end
end
