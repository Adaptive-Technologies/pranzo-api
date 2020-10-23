# frozen_string_literal: true

class Admin::TimeSheetsController < ApplicationController
  before_action :authenticate_user!
  before_action :format_options, only: :create
  def create
    if @error
      render json: @error, status: 422
    else
      time_sheet = current_user.time_sheets.create(@options)
      if time_sheet.persisted?
        render json: {
          timesheet: serialize(time_sheet), message: 'Your time sheet was submitted'
        }, status: :created
      end
    end
  end

  def index
    if current_user.admin?
      time_sheets = TimeSheet.for_current_period.group_by(&:user)
      render json: { users: serialize_grouped_collection(time_sheets) }
    else
      time_sheets = params[:previous] == 'true' ? current_user.time_sheets.for_previous_period : current_user.time_sheets.for_current_period
      render json: {
        user: Users::ShowSerializer.new(current_user),
        time_sheets: serialize_collection(time_sheets),
        total_hours: time_sheets.sum(:duration)
      }
    end
  end

  private

  def serialize(time_sheet)
    TimeSheets::ShowSerializer.new(time_sheet)
  end

  def serialize_collection(time_sheets)
    ActiveModelSerializers::SerializableResource.new(
      time_sheets,
      each_serializer: TimeSheets::IndexSerializer,
      adapter: :attributes,
      root: 'time_sheets'
    )
  end

  def serialize_grouped_collection(time_sheets)
    serialized = time_sheets.map do |group_object, sheets|
      serialized_sheets = serialize_collection(sheets)
      total_hours = sheets.pluck(:duration).sum
      [group_object.name, {
        user:  Users::ShowSerializer.new(group_object),
        time_sheets: serialized_sheets,
        total_hours: total_hours
      }]
    end.to_h
    serialized
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
      end_time: end_time
    }
  rescue StandardError => e
    @error = { message: 'Your request could not be fullfilled' }
  end

  def authenticate_user!
    super
  end
end
