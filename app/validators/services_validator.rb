# frozen_string_literal: true

class ServicesValidator < ActiveModel::EachValidator
  def validate_each(record, _attribute, values)
    if record.services.blank?
      record.errors.add(:services, 'must include at least one value')
    end
    values.each do |value|
      unless record.class.const_get('VALID_SERVICES').include? value
        record.errors.add(:services, "\"#{value}\" is an invalid value")
      end
    end
  end
end
