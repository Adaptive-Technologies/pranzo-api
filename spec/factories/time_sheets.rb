FactoryBot.define do
  factory :time_sheet do
    date { "2020-06-29" }
    start_time { "2020-06-29 16:46:44" }
    end_time { "2020-06-29 16:46:44" }
    duration { "9.99" }
    user 
  end
end
