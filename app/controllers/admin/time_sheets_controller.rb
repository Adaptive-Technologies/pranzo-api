# frozen_string_literal: true

class Admin::TimeSheetsController < ApplicationController
  before_action :authenticate_user!
  before_action :format_options, only: :create
  def create
    time_sheet = current_user.time_sheets.create(@options)
    if time_sheet.persisted?
      render json: {
        timesheet: serialize(time_sheet), message: 'Your time sheet was submitted'
      }, status: :created
    end
  end

  def index
    time_sheets = current_user.time_sheets.for_current_period
    render json: { user: Users::ShowSerializer.new(current_user), time_sheets: serialize_collection(time_sheets), total_hours: time_sheets.sum(:duration) }
  end

  private

  def serialize(time_sheet)
    TimeSheets::ShowSerializer.new(time_sheet)
  end

  def serialize_collection(time_sheets)
    ActiveModelSerializers::SerializableResource.new(
      time_sheets,
      each_serializer: TimeSheets::IndexSerializer,
      adapter: :attributes
    )
  end

  def valid_params
    params.require(:timesheet).permit!
  end

  def format_options
    start_time = Time.zone.parse(valid_params[:date].dup.insert(-1, " #{valid_params[:start_time]}"))
    end_time = Time.zone.parse(valid_params[:date].dup.insert(-1, " #{valid_params[:end_time]}"))
    @options = {
      date: Date.parse(valid_params[:date]),
      start_time: start_time,
      end_time: end_time,
    }
  end
end