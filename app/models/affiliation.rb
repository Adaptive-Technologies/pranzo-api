class Affiliation < ApplicationRecord
  belongs_to :vendor
  belongs_to :affiliate, class_name: 'Vendor'
end
