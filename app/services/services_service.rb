# frozen_string_literal: true

module ServicesService
  def self.current
    services = []
    lunch_start = DateTime.now.beginning_of_day + (11.hours + 30.minutes)
    lunch_end = DateTime.now.beginning_of_day + (14.hours + 30.minutes)
    dinner_start = DateTime.now.beginning_of_day + 17.hours
    dinner_end = DateTime.now.beginning_of_day + 20.hours
    services.push('lunch') if DateTime.now.between?(lunch_start, lunch_end)
    services.push('dinner') if DateTime.now.between?(dinner_start, dinner_end)
    services
  end
end
