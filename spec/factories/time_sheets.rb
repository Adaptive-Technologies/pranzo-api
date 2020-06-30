FactoryBot.define do
  factory :time_sheet do
    date { "2020-06-29" }
    start_time { "9:00" }
    end_time { "12" }
    user
  end
end
