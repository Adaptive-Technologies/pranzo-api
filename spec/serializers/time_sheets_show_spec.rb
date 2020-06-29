# frozen_string_literal: true

RSpec.describe TimeSheets::ShowSerializer, type: :serializer do
  let(:user) { create(:user) }
  let(:time_sheet) { create(:time_sheet, user: user) }
  let(:serialization) do
    ActiveModelSerializers::SerializableResource.new(
      time_sheet,
      serializer: described_class,
      scope: user,
      scope_name: :current_user
    )
  end

  subject { JSON.parse(serialization.to_json) }

  it 'is expected to wrap content in key reflecting model name' do
    expect(subject.keys).to match ['time_sheet']
  end

  it 'is expected to contain "id", "date", "start_time", "end_time", "duration" and "user"' do
    expected_keys = %w[id date start_time end_time duration user]
    expect(subject['time_sheet'].keys).to match expected_keys
  end

  it 'is expected to contain "id", "email" andd "name" for "user"' do
    expected_keys = %w[id email name]
    expect(subject['time_sheet']['user'].keys).to match expected_keys
  end

  it 'is expected to have a specific structure' do
    expect(subject).to match(
      'time_sheet' => {
        'id' => an_instance_of(Integer),
        'date' => an_instance_of(String),
        'start_time' => an_instance_of(String),
        'end_time' => an_instance_of(String),
        'duration' => an_instance_of(String),
        'user' => {
          'id' => an_instance_of(Integer),
          'name' => an_instance_of(String),
          'email' => a_string_including('@')
        }
      }
    )
  end
end
