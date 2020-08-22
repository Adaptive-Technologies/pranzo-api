# frozen_string_literal: true

class ServicesValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, values)
    if record.send(attribute).blank?
      record.errors.add(attribute, 'must include at least one value')
    end
    values.each do |value|
      unless record.class.const_get('VALID_SERVICES').include? value
        record.errors.add(attribute, "\"#{value}\" is an invalid value")
      end
    end
  end
end
