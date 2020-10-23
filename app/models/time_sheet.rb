# frozen_string_literal: true

class TimeSheet < ApplicationRecord
  belongs_to :user
  before_save :set_duration

  scope :for_current_period, lambda {
    where(date: (DateTime.now.beginning_of_month + 14)..(DateTime.now.end_of_month + 15))
  }

  scope :for_previous_period, lambda {
    where(date: (DateTime.now.months_ago(1).beginning_of_month + 14)..(DateTime.now.months_ago(1).end_of_month + 15))
  }

  private

  def set_duration
    self.duration = (end_time - start_time) / 1.minutes / 60
  end
end
