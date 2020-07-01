# frozen_string_literal: true

class TimeSheets::GroupedSerializer < ActiveModel::Serializer
  # Inspiration:
  # https://makandracards.com/bitcrowd/38771-group_by-with-activemodel-serializers

  def initialize(object, options = {})
    binding.pry
    super
  end
  def serializable_object(options={})
    @object.map do |group_key, objects|
      [group_key, serialized_objects(objects)]
    end.to_h
  end

  private

  def serialized_objects(objects)
    objects.map { |an_object| TimeSheets::ShowSerializer.new(an_object) }
  end
end
