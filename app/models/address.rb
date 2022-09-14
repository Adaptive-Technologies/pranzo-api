class Address < ApplicationRecord
  belongs_to :vendor
  validates_presence_of %i[street post_code city country]

  geocoded_by :full_address
  after_validation :geocode

  def full_address
    [street, post_code, city, country].join(', ')
  end
end
