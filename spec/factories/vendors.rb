# frozen_string_literal: true

FactoryBot.define do
  factory :vendor do
    name { Faker::Company.name }
    description { 'Instagram friendly food...' }
    primary_email { Faker::Internet.email }
    vat_id { 'SE556012579001' }
    after(:build) do |vendor|
      vendor.logotype.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'bocado_logo_color.png')),
        filename: "logo_#{vendor.name.downcase.parameterize(separator: '_')}.png",
        content_type: 'image/png'
      )
    end
  end
end
