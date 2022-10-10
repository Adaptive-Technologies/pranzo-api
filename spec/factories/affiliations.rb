FactoryBot.define do
  factory :affiliation do
    vendor 
    affiliate factory: :vendor 
  end
end
