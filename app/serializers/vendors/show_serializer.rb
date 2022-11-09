class Vendors::ShowSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :legal_name, :description, :primary_email, :vat_id, :logotype
  has_many :affiliates, serializer: Vendors::AffiliateSerializer
  has_many :users, serializer: Users::ShowSerializer
  has_many :addresses, serializer: Addresses::ShowSerializer

  def logotype
    return unless object.logotype

    if Rails.env.test?
      rails_blob_path(object.logotype, only_path: true)
    else
      object.logotype.url(expires_in: 1.hour, disposition: 'inline')
    end
  end
end
