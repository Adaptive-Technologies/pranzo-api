# frozen_string_literal: true

FactoryBot.define do
  factory :vendor do
    name { 'Bocado' }
    description { 'Instagram friendly food...' }
    primary_email { 'primary@mail.com' }
    after(:build) do |vendor|
      vendor.logotype.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'bocado_logo_color.png')),
        filename: "logo-#{vendor.name.underscore}.png",
        content_type: 'image/png'
      )
    end
  end
end
