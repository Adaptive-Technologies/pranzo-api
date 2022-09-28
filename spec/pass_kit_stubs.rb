RSpec.configure do |config|
  config.before(:each) do
    stub_request(:post, %r{/api.pub1.passkit.io/members/member})
      .to_return(status: 200, body: file_fixture('member_enroll_response.json').read.as_json, headers: {})
    stub_request(:put, %r{/members/member/points/burn})
      .to_return(status: 200, body: file_fixture('member_consume_points.json').read.as_json, headers: {})
    stub_request(:put, %r{/members/member/points/earn})
      .to_return(status: 200, body: file_fixture('member_refill_points.json').read.as_json, headers: {})
    # We also need a Google Geolocation stub
    stub_request(:get, %r{/maps.googleapis.com/maps/api/geocode/})
      .to_return(status: 200, body: file_fixture('google_geocode_api.json'), headers: {})
  end
end
