class TimeSheets::ShowSerializer < ActiveModel::Serializer
  attributes :id, :date, :start_time, :end_time, :duration, :user
  # belongs_to :user, serializer: Users::ShowSerializer

  def date
    object.date.to_s(:long)
  end

  def start_time
    object.start_time.strftime('%H:%M')
  end

  def end_time
    object.end_time.strftime('%H:%M')
  end

  def user
    Users::ShowSerializer.new(object.user)
  end

end
